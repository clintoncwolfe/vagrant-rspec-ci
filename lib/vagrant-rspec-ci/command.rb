module VagrantRspecCI

  class Command < Vagrant::Command::Base

    def execute
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant rpsec [vm-name]"
      end

      argv = parse_options(opts)
      return if !argv

      with_target_vms(argv[0]) do |vm|
        vm.env.action_runner.run(Vagrant::Action::General::Validate, {:vm=>vm, :ui=>vm.ui})

        if !vm.created? || vm.state != :running
          vm.ui.error("VM not running. Not running tests.")        
        else
         
          tests = expand_test_list(vm.config.rspec)
          cmd = rspec_command(vm)
          tests.each do |testfile|
            vm.ui.info("Running rspec test: #{testfile}")
            cmd = "#{cmd} #{testfile}"
            env = prep_env(vm)
            @logger.debug("Command: #{cmd}")
            @logger.debug("Environment: #{env.inspect()}")
            system(env, cmd)
            result = $?
            # rspec exits 0 if all passed, 1 if some failed - and system gives nil if there was a problem starting the process
            if result.nil? then
              vm.ui.error "Unable to execute rspec command: #{$!} \n #{cmd}"
            elsif result.exitstatus == 1 then
              vm.ui.warn "Rspec test #{testfile} has at least one failure - see report output for details"
            elsif result.exitstatus == 0 then
              vm.ui.success "Rspec test #{testfile} passed"
            else 
              vm.ui.error "Unrecognized exit code from rspec: #{result.exitstatus}\nfor:#{cmd}"
            end
          end

          if tests.empty?
            vm.ui.info("No rspec tests found.")
          end

        end
      end
    end

    private

    def prep_env(vm) 
      env = {}
      env["CI_REPORTS"] = vm.config.rspec.reports_dir

      # Needed so vagrant-gemmed bins (like rspec) can find ruby_noexec_wrapper
      env["PATH"] = ::Gem.bindir + ':' + ENV["PATH"]

      env
    end

    def expand_test_list (rspec_config) 
      tests = rspec_config.tests.map { |filespec|
        rspec_config.dirs.find_all { |dir| File.directory?(dir) }.map { |dir|          
          Dir.glob(File.join(dir, filespec))
        }
      }.flatten.uniq
    end

    def rspec_command (vm)
      # Use gemset provided by Vagrant
      # Cribbed from https://github.com/mitchellh/vagrant/blob/1-0-stable/lib/vagrant/command/gem.rb
      ENV['GEM_HOME'] = vm.env.gems_path.to_s
      ::Gem.clear_paths

      use_cir = vm.config.rspec.enable_ci_reporter

      # Find ci_reporter rspec hook
      if use_cir then
        ci_hook_candidates = ::Gem.find_files('ci/reporter/rake/rspec_loader')
        
        # TODO - bad assumption here, but if we find more than one, let's assume we can sort them and use the latest version.
        ci_hook_path = (ci_hook_candidates.sort)[-1]

        unless ci_hook_path then
          raise "Could not find ci_reporter rspec hook - I expect ci_reporter to be installed as a gem under vagrant!"
        end
      end

      # Find rspec
      # TODO - even when you install it as a vagrant gem, it is not present in ::Gem.bindir :(
      # Cross fingers?
      rspec_path = vm.config.rspec.rspec_bin_path

      cmd = ""
      cmd << rspec_path
      cmd << (use_cir ? " --require " + ci_hook_path + " --format CI::Reporter::RSpec" : "")
      cmd << (use_cir && vm.config.rspec.suppress_ci_stdout ? " -o /dev/null " : "")
      cmd << vm.config.rspec.dirs.map{ |d| " -I #{d}" }.join('')

      cmd
    end

  end

end
