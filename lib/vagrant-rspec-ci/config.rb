module VagrantRspecCI

  class Config < Vagrant::Config::Base

    attr_writer :enable_ci_reporter, 
    :suppress_ci_stdout,
    :rspec_bin_path,
    :reports_dir,
    :dirs,
    :tests

    def enable_ci_reporter
      @enable_ci_reporter.nil? ? true : @enable_ci_reporter
    end

    def suppress_ci_stdout
      @suppress_ci_stdout.nil? ? true : @suppress_ci_stdout
    end

    def rspec_bin_path
      if @rpsec_bin_path then
        return @rpsec_bin_path
      else
        guess = File.join(::Gem.bindir, 'rspec')
        return File.exists?(guess) ? guess : DEFAULT_RSPEC_BIN_PATH
      end
    end

    def reports_dir
      @reports_dir || DEFAULT_REPORTS_DIR
    end

    def dirs
      @dirs || DEFAULT_DIRS
    end

    def tests
      @tests || DEFAULT_TESTS
    end

    def validate(env, errors)

      [
       :dirs,
       :tests,
      ].each do |thing_sym|
        # Each of these should be an array or enumerable.
        value = self.send(thing_sym)
        unless value.respond_to?(:each) then
          errors.add("config.rspec.#{thing_sym} should be an array")
          return
        end
      end
       
      # Must find at least one of the directory defaults
      edir = self.dirs.find {|d| File.directory?(d) }
      errors.add("No test directory found - candidates: #{self.dirs.join(',')}") unless edir

    end

  end

end
