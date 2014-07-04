module Manganese
  module Tenancy
    extend ActiveSupport::Concern

    included do
      store_in database: -> { current_tenant_name }
    end

    def current_tenant_name
      self.class.current_tenant_name
    end

    module ClassMethods
      def current_tenant_name
        Manganese.current_tenant
      end
    end
  end
end
