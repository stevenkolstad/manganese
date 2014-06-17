require "manganese/version"
require "manganese/tenant"
require "manganese/tenancy"

module Manganese

  class << self

    def current_tenant=(tenant)
      self.default_db
      Thread.current[:tenant] = tenant
    end

    def current_tenant
      Thread.current[:tenant] || self.default_db
    end

    def default_db
      @default_db ||= Mongoid.default_session.options[:database]
    end

  end

end
