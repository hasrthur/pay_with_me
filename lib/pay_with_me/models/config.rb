module PayWithMe
  module Models
    class Config
      class Dummy
        def initialize(allowed_options)
          @allowed_options = allowed_options
        end

        def hash
          @hash ||= {}
        end

        def configure
          yield self
        end

        def method_missing(name, value)
          unless @allowed_options.include? name
            raise UnsupportedConfigurationOption, "Unsupported configuration option `#{ name }`"
          end

          hash[name] = value
        end
      end

      def self.create(allowed_options, &block)
        dummy = Dummy.new(allowed_options)
        dummy.configure &block

        new(dummy.hash)
      end

      def initialize(configuration_hash)
        @configuration_hash = configuration_hash
      end

      def method_missing(option_name, *args, &block)
        return @configuration_hash[option_name] if @configuration_hash.key? option_name

        super
      end
    end
  end
end