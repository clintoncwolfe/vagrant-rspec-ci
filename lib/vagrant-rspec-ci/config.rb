module VagrantRspecCI

  class Config < Vagrant::Config::Base

    attr_writer :enable_ci_reporter, 
    :external_rspec_bin_path,
    :external_reports_dir,
    :external_dirs,
    :external_tests,

    :internal_rspec_bin_path,
    :internal_reports_dir,
    :internal_tests, 
    :internal_dirs

    def enable_ci_reporter
      @enable_ci_reporter.nil? ? true : @enable_ci_reporter
    end

    def external_rspec_bin_path
      @external_rpsec_bin_path || DEFAULT_EXTERNAL_RSPEC_BIN_PATH
    end

    def internal_rspec_bin_path
      @internal_rpsec_bin_path || DEFAULT_INTERNAL_RSPEC_BIN_PATH
    end

    def external_reports_dir
      @external_reports_dir || DEFAULT_EXTERNAL_REPORTS_DIR
    end

    def internal_reports_dir
      @internal_reports_dir || DEFAULT_INTERNAL_REPORTS_DIR
    end

    def external_dirs
      @external_dirs || DEFAULT_EXTERNAL_DIRS
    end

    def internal_dirs
      @internal_dirs || DEFAULT_INTERNAL_DIRS
    end

    def internal_tests
      @internal_tests || DEFAULT_INTERNAL_TESTS
    end

    def external_tests
      @external_tests || DEFAULT_EXTERNAL_TESTS
    end

    def validate(env, errors)

      [
       :external_dirs,
       :internal_dirs,
       :external_tests,
       :internal_tests,
      ].each do |thing_sym|
        # Each of these should be an array or enumerable.
        value = self.send(thing_sym)
        unless value.respond_to?(:each) then
          errors.add("config.rspec.#{thing_sym} should be an array")
          return
        end
      end
       
      # Must find at least one of the external directory defaults
      edir = self.external_dirs.find {|d| File.directory?(d) }
      errors.add("No external test directory found - candidates: #{self.external_dirs.join(',')}") unless edir

      # Must find at least one of the external directory defaults
      # Note that we assume we are in the vagrant project root dir, so cwd (host) == /vagrant (guest)
      idir = self.internal_dirs.find {|d| File.directory?(d) }
      errors.add("No internal test directory found - candidates: #{self.internal_dirs.join(',')}") unless idir

    end

  end

end
