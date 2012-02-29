module VagrantTest

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
        elsif (vm.config.test.internal_tests + vm.config.test.external_tests).empty?
          vm.ui.error("No tests defined.")
        else

          unless vm.config.test.internal_tests.empty?
            internal_tests = vm.config.test.internal_tests.map { |obj|
              File.join(V_ROOT, vm.config.test.dir, obj)
            }.join(", ")
            vm.ui.info("Running internal test(s): #{internal_tests}")
            vm.channel.sudo("#{vm.config.test.command} #{internal_tests}") do |type,data|
              print data if type == :stdout
            end
          end

          unless vm.config.test.external_tests.empty?
            external_tests = vm.config.test.external_tests.map { |obj|
              File.join(vm.config.test.dir, obj)
            }.join(", ")
            vm.ui.info("Running external test(s): #{external_tests}")
            system("#{vm.config.test.command} #{external_tests}")
          end
        end
      end
    end

  end

end
