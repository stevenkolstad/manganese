require 'rake'
require 'rake/tasklib'

require 'mongoid/tasks/database'

module Manganese
  module Rake
    # Manganese Rake task macros.
    class CreateIndexesTask < ::Rake::TaskLib

      def initialize
        yield self if block_given?
        define
      end

      def define
        namespace :'db:manganese' do
          desc 'Create the indexes defined on your mongoid models foreach tenat'
          task create_indexes: [:environment, :'db:mongoid:load_models'] do
            self.create_indexes!
          end
        end
      end

      # Retrieve all models defines as Tenant
      def tenant_models
        @tenant_models ||= Mongoid.models.select do |model|
          model.respond_to?(:manganese_tenat?) && model.manganese_tenat?
        end
      end

      def create_main_database_indexes
        logger.info "MANGANESE: Creating indexes for the main '#{Manganese.default_db}' database"
        Mongoid::Tasks::Database.create_indexes
      end

      def create_tenant_indexes(model)
        logger.info "MANGANESE: Creating indexes for the tenant '#{model.tenant_name}' database"
        model.switch_db
        Mongoid::Tasks::Database.create_indexes
      end

      # Create indexes foreach Tenant
      def create_indexes!
        self.create_main_database_indexes

        self.tenant_models.each do |model|
          model.each do |tenant|
            self.create_tenant_indexes(tenant)
          end
        end
      end

      private

        def logger
          @logger ||= Logger.new($stdout)
        end
    end
  end
end
