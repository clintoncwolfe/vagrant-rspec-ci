module VagrantPlugins
  module VagrantRspecCI
    class Plugin < Vagrant.plugin("2")
      name "Run rspec tests against a VM, with jUnit output"
      
      #command "rspec" do
      #  require_relative "command"
      #  VagrantPlugins::VagrantRspecCI::Command
      #end

      config "rspec" do
        require_relative "config"
        VagrantPlugins::VagrantRspecCI::Config
      end

    end
  end
end
