require 'active_support/concern'
require 'mongoid'
require 'manganese/version'
require 'manganese/tenant'
require 'manganese/tenancy'

module Manganese
  class << self
    def current_tenant=(database_name)
      self.default_db
      Thread.current[:tenant] = database_name
    end

    def current_tenant
      Thread.current[:tenant] || self.default_db
    end

    def reset_tenant!
      Thread.current[:tenant] = nil
    end

    def default_db
      @default_db ||= Mongoid.default_session.options[:database].to_s
    end
  end
end
