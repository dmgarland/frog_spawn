module FrogSpawn
  module Server
    class << self
      def start
        puts "Starting PHP server on http://#{host}:#{port}\n\n"

        # Create log file
        FileUtils.mkdir_p log_dir

        # Start PHP and write the process ID to a file
        opts = {
          [:out, :err] => ["#{log_dir}/php_#{php_env['PHP_ENV']}.log", "a"],
          :chdir => Dir.pwd,
          :pgroup => true
        }
        cmd = "php -S #{host}:#{port} -d variables_order=EGPCS -t #{root_dir}"
        pid = spawn(php_env, "sh", "-c", cmd, opts)
        FileUtils.mkdir_p pid_dir
        File.open(pid_file, 'w') {|f| f.write pid }
      end

      # Kill the PHP process and delete the PID file
      def stop
        pid = File.read(pid_file).chomp.to_i
        gpid = Process.getpgid(pid)
        Process.kill(-15, gpid)
        FileUtils.rm pid_file
      end

      protected

      def php_env
        @php_env ||= { 'PHP_ENV' => ENV['PHP_ENV'] || 'development'}
      end

      def pid_file
        @pid_file ||= "#{pid_dir}/php_#{php_env['PHP_ENV']}.pid"
      end

      def pid_dir
        @pid_dir ||= (ENV['pid_dir'] || "#{root_dir}/tmp")
      end

      def log_dir
        @log_dir ||= (ENV['log_dir'] || "#{root_dir}/log")
      end

      def root_dir
        @root_dir ||= (ENV['root_dir'] || Rake.application.original_dir)
      end

      def host
        @host ||= (ENV['host'] || 'localhost')
      end

      def port
        @port ||= (ENV['port'] || 8000)
      end
    end
  end
end