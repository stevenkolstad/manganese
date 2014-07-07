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
    alias_method :real_current_session, :current_session

    def current_tenant=(database_name)
      self.tenants_history << database_name

      if Manganese::Testing.fake?
        self.tenants_history.last
      else
        self.real_current_tenant = database_name
      end
    end

    def tenants_history
      @tenants_history ||= [ Manganese.default_db ]
    end

    def current_tenant
      if Manganese::Testing.fake?
        self.tenants_history.last
      else
        self.real_current_tenant
      end
    end

    def reset_tenant!
      self.tenants_history << Manganese.default_db
      self.real_reset_tenant!
    end

    def current_session(&block)
      if Manganese::Testing.fake?
        Mongoid.default_session().with(database: Manganese.default_db, &block)
      else
        self.real_current_session(&block)
      end
    end
  end

  module Tenancy
    module ClassMethods
      alias_method :real_current_tenant_name, :current_tenant_name

      def current_tenant_name
        if Manganese::Testing.fake?
          Manganese.default_db
        else
          self.real_current_tenant_name
        end
      end
    end
  end
end

# Default to fake testing
Manganese::Testing.fake!
