require 'manganese'

module Manganese

  class Testing
    class << self
      attr_accessor :__test_mode

      def __set_test_mode(mode, &block)
        if block
          current_mode = self.__test_mode
          begin
            self.__test_mode = mode
            block.call
          ensure
            self.__test_mode = current_mode
          end
        else
          self.__test_mode = mode
        end
      end

      def live!(&block)
        __set_test_mode(:live, &block)
      end

      def fake!(&block)
        __set_test_mode(:fake, &block)
      end

      def live?
        self.__test_mode == :live
      end

      def fake?
        self.__test_mode == :fake
      end
    end
  end

  class << self
    alias_method :real_current_tenant=, :current_tenant=
    alias_method :real_current_tenant,  :current_tenant
    alias_method :real_reset_tenant!,   :reset_tenant!

    def current_tenant=(database_name)
      tenant_history << database_name

      if Manganese::Testing.fake?
        tenant_history.last
      else
        real_current_tenant = database_name
      end
    end

    def current_tenant
      if Manganese::Testing.fake?
        tenant_history.last
      else
        real_current_tenant
      end
    end

    def reset_tenant!
      tenant_history << Manganese.default_db
      real_reset_tenant!
    end

    def tenant_history
      @tenant_history ||= [ Manganese.default_db ]
    end
  end

  module Tenancy
    module ClassMethods
      alias_method :real_current_tenant_name, :current_tenant_name

      def current_tenant_name
        if Manganese::Testing.fake?
          Manganese.default_db
        else
          real_current_tenant_name
        end
      end
    end
  end
end

# Default to fake testing
Manganese::Testing.fake!
