require "vagrant"
require "vagrant-test/config"
require "vagrant-test/command"

module VagrantTest

  NAME            = "vagrant-test"
  VERSION         = "0.1.0"
  AUTHOR          = "Michael Paul Thomas Conigliaro"
  AUTHOR_EMAIL    = "mike [at] conigliaro [dot] org"
  DESCRIPTION     = "vagrant-test is a simple Vagrant plugin for running tests on your VMs."
  URL             = "http://github.com/mconigliaro/vagrant-test"

  V_ROOT          = "/vagrant"
  DEFAULT_COMMAND = "rspec -f doc"
  DEFAULT_DIR     = "spec"

end

Vagrant.config_keys.register(:test) { VagrantTest::Config }
Vagrant.commands.register(:test) { VagrantTest::Command }
