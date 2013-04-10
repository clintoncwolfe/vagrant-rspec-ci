module VagrantRspecCI

  class Config < Vagrant::Config::Base

    attr_writer :command, :external_dirs, :internal_dirs, :internal_tests, :external_tests

    def command
      @command || DEFAULT_COMMAND
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

      # [:internal_tests, :external_tests].inject({}) { |memo,obj|
      #   memo.merge({ obj => self.send(obj.to_sym) })
      # }.each do |name,value|
      #   if value.respond_to?(:each)
      #     value.each do |obj|
      #       file = File.join(dir, obj)
      #       errors.add("File not found: #{file}") unless File.exists?(file)
      #     end
      #   else
      #     errors.add("#{name} is not enumerable")
      #   end
      # end
    end

  end

end
