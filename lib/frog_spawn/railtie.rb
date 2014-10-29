module FrogSpawn
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/php.rake"
    end
  end
end