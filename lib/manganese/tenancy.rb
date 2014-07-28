module Manganese
  module Tenancy
    extend ActiveSupport::Concern

    included do
      store_in database: -> { self.current_tenant_name }
    end

    def current_tenant_name
      self.class.current_tenant_name
    end

    def manganese_tenat?
      false
    end

    def manganese_tenancy?
      true
    end

    module ClassMethods
      def current_tenant_name
        Manganese.current_tenant
      end

      def manganese_tenat?
        false
      end

      def manganese_tenancy?
        true
      end
    end
  end
end
