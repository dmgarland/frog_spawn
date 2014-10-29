namespace :php do
  namespace :server do

    desc "Starts the PHP server"
    task :start => :environment do
      FrogSpawn::Server.start
    end

    desc "Stops the PHP server"
    task :stop => :environment do
      FrogSpawn::Server.stop
    end
  end

end