module VagrantRspecCI

  class Command < Vagrant::Command::Base

    def execute
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant test [vm-name]"
      end

      argv = parse_options(opts)
      return if !argv

      with_target_vms(argv[0]) do |vm|
        vm.env.action_runner.run(Vagrant::Action::General::Validate, {:vm=>vm, :ui=>vm.ui})

        if !vm.created? || vm.state != :running
          vm.ui.error("VM not running. Not running tests.")
        elsif (vm.config.rspec.internal_tests + vm.config.rspec.external_tests).empty?
          vm.ui.error("No tests defined.")
        else
         
          expand_internal_test_list(vm.config.rspec).each do |testfile|
            vm.ui.info("Running internal test: #{testfile}")
            system("#{vm.config.rspec.command} #{testfile}")
          end

          expand_external_test_list(vm.config.rspec).each do |testfile|
            vm.ui.info("Running external test: #{testfile}")
            system("#{vm.config.rspec.command} #{testfile}")
          end
        end
      end
    end

    private
    def expand_external_test_list (rspec_config) 
      external_tests = rspec_config.external_tests.map { |filespec|
        rspec_config.external_dirs.find_all { |dir| File.directory?(dir) }.map { |dir|
          path = File.join(dir, filespec)
          File.exists?(path) ? path : nil
        }
      }.flatten.uniq.reject{|p| p.nil?}
    end

    def expand_internal_test_list (rspec_config) 
      internal_tests = rspec_config.internal_tests.map { |filespec|
        rspec_config.internal_dirs.find_all { |dir| File.directory?(dir) }.map { |dir|
          host_pov_path = File.join(dir, filespec)
          guest_pov_path = File.join(V_ROOT, filespec)
          File.exists?(host_pov_path) ? guest_pov_path : nil
        }
      }.flatten.uniq.reject{|p| p.nil?}
    end


  end

end
