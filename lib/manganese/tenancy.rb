module Manganese
  module Tenancy
    extend ActiveSupport::Concern

    included do
      store_in database: -> { Manganese.current_tenant }
    end
  end
end
