module VagrantRspecCI

  class Config < Vagrant::Config::Base

    attr_writer :command, :dir, :internal_tests, :external_tests

    def command
      @command || DEFAULT_COMMAND
    end

    def dir
      @dir || DEFAULT_DIR
    end

    def internal_tests
      @internal_tests || []
    end

    def external_tests
      @external_tests || []
    end

    def validate(env, errors)
      errors.add("Test directory not found: #{dir}") unless File.directory?(dir)
      [:internal_tests, :external_tests].inject({}) { |memo,obj|
        memo.merge({ obj => send(obj.to_sym) })
      }.each do |name,value|
        if value.respond_to?(:each)
          value.each do |obj|
            file = File.join(dir, obj)
            errors.add("File not found: #{file}") unless File.exists?(file)
          end
        else
          errors.add("#{name} is not enumerable")
        end
      end
    end

  end

end
