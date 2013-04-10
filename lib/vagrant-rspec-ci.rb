require "rubygems"

require "vagrant"
require "vagrant-rspec-ci/config"
require "vagrant-rspec-ci/command"

module VagrantRspecCI

  NAME            = "vagrant-rspec-ci"
  VERSION         = "0.0.1"
  AUTHOR          = "Clinton Wolfe"
  AUTHOR_EMAIL    = "clintoncwolfe [at] gmail [dot] com"
  DESCRIPTION     = "vagrant-rspec-ci is a Vagrant plugin for running tests on your VMs, derived from vagrant-test"
  URL             = "http://github.com/clintoncwolfe/vagrant-rspec-ci"

  V_ROOT          = "/vagrant"
  DEFAULT_COMMAND = "rspec -f doc"
  DEFAULT_EXTERNAL_DIRS    = [ "combined/spec_ext", "spec" ]
  DEFAULT_INTERNAL_DIRS    = [ "combined/spec_int", "spec" ]

end

Vagrant.config_keys.register(:rspec) { VagrantRspecCI::Config }
Vagrant.commands.register(:rspec) { VagrantRspecCI::Command }
