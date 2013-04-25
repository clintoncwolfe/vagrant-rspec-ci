module VagrantRspecCI
  class Plugin < Vagrant.plugin("2")
    name "Run rspec tests against a VM, with jUnit output"

    command "rspec" do
      require_relative "command"
      next VagrantRspecCI::Command
    end

    config "rspec" do
      require_relative "config"
      Config
    end

  end
end
