require 'active_support/concern'

require 'mongoid'

require 'manganese/version'
require 'manganese/tenant'
require 'manganese/tenancy'

# If we are using Rails then we will include the Mongoid railtie.
# This has all the nifty initializers that Manganese needs.
if defined?(Rails)
  require 'manganese/railtie'
end

module Manganese
  class << self
    def default_db
      @default_db ||= Mongoid.default_session.options[:database].to_s
    end

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

    # Retrive the current session
    #
    # @example Retrieve a `sample_collection` in the current tenant
    #   Manganese.current_session do |session|
    #     session[:sample_collection]
    #   end
    def current_session(&block)
      Mongoid.default_session().with(database: Manganese.current_tenant, &block)
    end

    def with_tenant(tenant, &block)
      tmp_current_tenant = Manganese.current_tenant
      Manganese.current_tenant = tenant
      block.call
    ensure
      Manganese.current_tenant = tmp_current_tenant
    end
  end
end
