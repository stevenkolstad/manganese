require 'manganese/rake/create_indexes_task'

module Manganese
  class Railtie < ::Rails::Railtie
    rake_tasks do
      Rake::CreateIndexesTask.new
    end
  end
end
