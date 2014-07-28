module Manganese
  module Tenant
    extend ActiveSupport::Concern

    def tenant_name
      @tenant_name ||= "#{::Manganese.default_db}_#{self._id}"
    end

    def switch_db
      Manganese.current_tenant = tenant_name
    end

    def reset_db
      Manganese.reset_tenant!
    end

    def manganese_tenat?
      true
    end

    def manganese_tenancy?
      false
    end

    module ClassMethods
      def manganese_tenat?
        true
      end

      def manganese_tenancy?
        false
      end
    end
  end
end
