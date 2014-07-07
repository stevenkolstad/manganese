module Manganese
  module Tenant
    extend ActiveSupport::Concern

    def switch_db
      Manganese.current_tenant = "#{::Manganese.default_db}_#{self._id}"
    end

    def reset_db
      Manganese.reset_tenant!
    end
  end
end
