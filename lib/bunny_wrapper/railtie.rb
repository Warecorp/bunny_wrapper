require 'bunny_wrapper'
require 'rails'

module BunnyWrapper
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'bunny_wrapper/tasks.rake'
    end
  end
end
