# frozen_string_literal: true

module PayWithMe
  module Models
    class Config
      def self.create(allowed_options)
        new(allowed_options).tap do |c|
          generate_methods_for! c, with_allowed: allowed_options

          yield c if block_given?
        end
      end

      def self.generate_methods_for!(config, with_allowed: [])
        with_allowed.each do |method_name|
          config.instance_eval <<-METHOD, __FILE__, __LINE__ + 1
              def #{method_name}(value = nil)      # def account_id(value = nil)
                if value                             #   if value
                  @#{method_name} = value          #     @account_id = value
                else                                 #   else
                  @#{method_name}                  #     @account_id
                end                                  #   end
              end                                    # end
          METHOD
        end
      end

      def initialize(allowed_options)
        @allowed_options = allowed_options
      end

      def configure
        yield self
      rescue NoMethodError => e
        raise UnsupportedConfigurationOption, "Unsupported configuration option `#{e.name}`"
      end
    end
  end
end
