# frozen_string_literal: true

module PayWithMe
  class Configurator
    def self.make_configs(configs, supported_systems, allowed_options, &block)
      new(configs, supported_systems, allowed_options).make_configs(&block)
    end

    def self.from_yaml_file(configs, supported_systems, allowed_options, path_to_config)
      yaml = YAML.load_file(path_to_config)
      make_configs(configs, supported_systems, allowed_options) do |c|
        yaml.each do |payment_system, options|
          c.configure(payment_system) do |ps|
            options.each do |k, v|
              ps.send k, v
            end
          end
        end
      end
    end

    def initialize(configs, supported_systems, allowed_options)
      @configs = configs
      @supported_systems = supported_systems
      @allowed_options = allowed_options

      initialize_configs!
    end

    def make_configs
      yield self
    end

    def configure(payment_system, &block)
      payment_system = payment_system.to_sym
      unless @supported_systems.include?(payment_system)
        raise UnsupportedPaymentSystem, "Trying to configure `#{payment_system}` which is not supported"
      end

      @configs[payment_system].configure(&block)
    end

    private

    def initialize_configs!
      @supported_systems.each do |payment_system|
        @configs[payment_system] ||= Models::Config.create(@allowed_options[payment_system])
      end
    end
  end
end
