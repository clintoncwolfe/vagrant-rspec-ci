require "rubygems"

require "vagrant"
require "vagrant/util/subprocess"  # TODO verify under vagrant 1.1


module VagrantRspecCI

  NAME            = "vagrant-rspec-ci"
  VERSION         = "0.0.4"
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
