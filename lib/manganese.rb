require "manganese/version"
require "manganese/tenant"
require "manganese/tenancy"

module Manganese

  class << self

    def current_tenant=(tenant)
      Thread.current[:tenant] = tenant
    end

    def current_tenant
      Thread.current[:tenant]
    end

  end

end
