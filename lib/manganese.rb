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
    # Retrieve the main database
    #
    # @example Retrieve the main database
    #   Manganese.default_db
    def default_db
      @default_db ||= Mongoid.default_session.options[:database].to_s
    end


    # Set the current tenant database
    #
    # @example
    #   Manganese.current_tenant = 'custom_tenant_name'
    def current_tenant=(database_name)
      self.default_db
      Thread.current[:tenant] = database_name
    end


    # Get the current tenant
    #
    # @example
    #   Manganese.current_tenant
    #
    # @return [ String ]
    def current_tenant
      Thread.current[:tenant] || self.default_db
    end

    # Reset the current tenant database
    #
    # @example
    #   Manganese.reset_tenant
    #
    # @return [ nil ]
    def reset_tenant!
      Thread.current[:tenant] = nil
    end

    # Retrieve the current session
    #
    # @example Retrieve a `sample_collection` in the current tenant
    #   Manganese.current_session do |session|
    #     session[:sample_collection]
    #   end
    def current_session(&block)
      Mongoid.default_session().with(database: Manganese.current_tenant, &block)
    end


    # Helper method to switch temporary to another tenant
    #
    # @example
    #   Manganese.with_tenant 'sample_tenant_name' do
    #     # do something...
    #   end
    def with_tenant(tenant, &block)
      tmp_current_tenant = Manganese.current_tenant
      Manganese.current_tenant = tenant
      block.call
    ensure
      Manganese.current_tenant = tmp_current_tenant
    end
  end
end
