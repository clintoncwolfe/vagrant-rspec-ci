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
         
          internal_tests = expand_internal_test_list(vm.config.rspec)
          internal_cmd = internal_command(vm)
          internal_tests.each do |testfile|
            vm.ui.info("Running internal test: #{testfile}")
            vm.channel.sudo("#{internal_cmd} #{testfile}") do |type,data|
              print data if type == :stdout
            end
          end

          external_tests = expand_external_test_list(vm.config.rspec)
          external_cmd = external_command(vm)
          external_tests.each do |testfile|
            vm.ui.info("Running external test: #{testfile}")
            cmd = "#{external_cmd} #{testfile}"
            @logger.debug("Command: #{cmd}")
            system("#{cmd}")
          end

          if (internal_tests + external_tests).empty?
            vm.ui.info("No rspec tests found.")
          end

        end
      end
    end

    private
    def expand_external_test_list (rspec_config) 
      external_tests = rspec_config.external_tests.map { |filespec|
        rspec_config.external_dirs.find_all { |dir| File.directory?(dir) }.map { |dir|          
          Dir.glob(File.join(dir, filespec))
        }
      }.flatten.uniq
    end

    def expand_internal_test_list (rspec_config) 
      internal_tests = rspec_config.internal_tests.map { |filespec|
        rspec_config.internal_dirs.find_all { |dir| File.directory?(dir) }.map { |dir|
          host_pov_hits = Dir.glob(File.join(dir, filespec))
          guest_pov_hits = host_pov_hits.map{ |f| f.sub(dir,V_ROOT) }
        }
      }.flatten.uniq
    end

    def internal_command (vm)
      # TODO - should this do anything magical, like installing rspec/ci_reporter/other gems?
    end

    def external_command (vm)
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
      rspec_path = vm.config.rspec.external_rspec_bin_path

      cmd = (use_cir ? "CI_REPORTS=" + vm.config.rspec.external_reports_dir + " " : "") +
        rspec_path +
        (use_cir ? " --require " + ci_hook_path + " --format CI::Reporter::RSpec" : "") +
        vm.config.rspec.external_dirs.map{ |d| " -I #{d}" }.join('')

    end

  end

end
