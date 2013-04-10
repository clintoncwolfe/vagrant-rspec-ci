require "rubygems"

require "vagrant"
require "vagrant/util/subprocess"
require "vagrant-rspec-ci/config"
require "vagrant-rspec-ci/command"



require "pry-debugger"

module VagrantRspecCI

  NAME            = "vagrant-rspec-ci"
  VERSION         = "0.0.1"
  AUTHOR          = "Clinton Wolfe"
  AUTHOR_EMAIL    = "clintoncwolfe [at] gmail [dot] com"
  DESCRIPTION     = "vagrant-rspec-ci is a Vagrant plugin for running tests against your VMs, derived from vagrant-test"
  URL             = "http://github.com/clintoncwolfe/vagrant-rspec-ci"

  V_ROOT          = "/vagrant"


  DEFAULT_RSPEC_BIN_PATH  = "rspec"
  DEFAULT_REPORTS_DIR     = "rspec_reports"
  DEFAULT_DIRS            = [ "combined/spec_ext", "spec" ]
  DEFAULT_TESTS           = [ "*spec.rb" ]


end

Vagrant.config_keys.register(:rspec) { VagrantRspecCI::Config }
Vagrant.commands.register(:rspec) { VagrantRspecCI::Command }
