module Manganese
  module Tenant
    extend ActiveSupport::Concern

    def switch_db
      Manganese.current_tenant = "#{Rails.env}_#{self._id}"
    end

    def reset_db
      Manganese.current_tenant = nil
    end

  end
end
