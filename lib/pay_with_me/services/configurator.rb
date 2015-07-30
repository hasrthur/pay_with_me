module PayWithMe
  class Configurator
    def self.make_configs(supported_systems, allowed_options, &block)
      new(supported_systems, allowed_options).make_configs(&block)
    end

    def initialize(supported_systems, allowed_options)
      @supported_systems = supported_systems
      @allowed_options = allowed_options
    end

    def make_configs(&block)
      instance_exec(&block)

      configs_hash
    end

    def configs_hash
      @configs_hash ||= {}
    end

    private

    def configure(payment_system, &block)
      payment_system = payment_system.to_sym
      unless @supported_systems.include?(payment_system)
        raise UnsupportedPaymentSystem, "Trying to configure `#{ payment_system }` which is not supported"
      end

      configs_hash[payment_system] = Models::Config.create(@allowed_options[payment_system], &block)
    end
  end
end