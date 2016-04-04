module VagrantPlugins
  module VagrantRspecCI

    class Config < Vagrant.plugin(2, :config)

      attr_accessor :enable_ci_reporter, 
      :suppress_ci_stdout,
      :rspec_bin_path,
      :reports_dir,
      :dirs,
      :tests

      def initialize
        @enable_ci_reporter = UNSET_VALUE 
        @suppress_ci_stdout = UNSET_VALUE
        @rspec_bin_path = UNSET_VALUE
        @reports_dir = UNSET_VALUE
        @dirs = UNSET_VALUE
        @tests = UNSET_VALUE
      end

      def finalize! 
        # Set defaults if unset         
        @enable_ci_reporter = true if @enable_ci_reporter == UNSET_VALUE
        @suppress_ci_stdout = true if @suppress_ci_stdout == UNSET_VALUE
        @reports_dir = DEFAULT_REPORTS_DIR if @reports_dir == UNSET_VALUE
        @dirs        = DEFAULT_DIRS        if @dirs == UNSET_VALUE
        @tests = DEFAULT_TESTS if @tests == UNSET_VALUE
        
        if @rspec_bin_path == UNSET_VALUE then
          guess = guess_rspec_bin_path
          @rspec_bin_path = File.exists?(guess) ? guess : DEFAULT_RSPEC_BIN_PATH
        end
      end

      def guess_rspec_bin_path
        rspec_version = ::Gem::Specification::find_by_name('rspec').version
        ::Gem.bin_path rspec_version >= Gem::Version.new('2.0.0.a2') ? 'rspec-core' : 'rspec', 'rspec'
      end

      # TODO check args to this
      def validate(machine)
        errors = { "vagrant-rspec-ci" => [] }
        
        [
         :dirs,
         :tests,
        ].each do |thing_sym|
          # Each of these should be an array or enumerable.
          value = self.send(thing_sym)
          unless value.respond_to?(:each) then
            errors["vagrant-rspec-ci"].push("config.rspec.#{thing_sym} should be an array")
          end
        end
        
        # Must find at least one of the directory defaults
        edir = self.dirs.find {|d| File.directory?(d) }
        errors["vagrant-rspec-ci"].push("No test directory found - candidates: #{self.dirs.join(',')}") unless edir
      end
    end
  end
end
