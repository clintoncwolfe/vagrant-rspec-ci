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
        else
         
          internal_tests = expand_internal_test_list(vm.config.rspec)
          internal_tests.each do |testfile|
            vm.ui.info("Running internal test: #{testfile}")
            vm.channel.sudo("#{vm.config.test.command} #{testfile}") do |type,data|
              print data if type == :stdout
            end
          end

          external_tests = expand_external_test_list(vm.config.rspec)
          external_tests.each do |testfile|
            vm.ui.info("Running external test: #{testfile}")
            system("#{vm.config.rspec.command} #{testfile}")
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
          # TODO will this match anything if they are broken symlinks from host's POV?
          host_pov_hits = Dir.glob(File.join(dir, filespec))
          guest_pov_hits = host_pov_hits.map{ |f| f.sub(dir,V_ROOT) }
        }
      }.flatten.uniq
    end


  end

end
