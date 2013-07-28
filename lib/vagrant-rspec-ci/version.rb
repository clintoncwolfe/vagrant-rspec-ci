module VagrantPlugins
  module VagrantRspecCI

    NAME            = "vagrant-rspec-ci"
    VERSION         = "0.1.0"
    AUTHOR          = "Clinton Wolfe"
    AUTHOR_EMAIL    = "clintoncwolfe [at] gmail [dot] com"
    DESCRIPTION     = "vagrant-rspec-ci is a Vagrant 1.2.x plugin for running tests against your VMs, derived from vagrant-test"
    SUMMARY         = "Run rspec tests against a Vagrant VM test subject"
    URL             = "http://github.com/clintoncwolfe/vagrant-rspec-ci"
    
    V_ROOT          = "/vagrant"


    DEFAULT_RSPEC_BIN_PATH  = "rspec"
    DEFAULT_REPORTS_DIR     = "rspec_reports"
    DEFAULT_DIRS            = [ "combined/spec_ext", "spec" ]
    DEFAULT_TESTS           = [ "*spec.rb" ]

  end
end
