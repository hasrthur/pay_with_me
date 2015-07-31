require 'net/http'
require 'nokogiri'

require_relative 'pay_with_me/version'

# models
require_relative 'pay_with_me/models/response'
require_relative 'pay_with_me/models/balance'
require_relative 'pay_with_me/models/config'
require_relative 'pay_with_me/models/transfer'

require_relative 'pay_with_me/payment_system'

# services
require_relative 'pay_with_me/services/configurator'

# PerfectMoney
require_relative 'pay_with_me/payment_systems/perfect_money/api/balance_retriever'
require_relative 'pay_with_me/payment_systems/perfect_money/api/transferer'

require_relative 'pay_with_me/payment_systems/perfect_money/models/transfer'

module PayWithMe
  # key here is the shorthand which will be used by users of the gem
  # value is the module name for the payment system
  SUPPORTED_SYSTEMS = {
      :perfect_money => {
          :module          => :PerfectMoney,
          :allowed_options => %i( account_id password payer )
      }
  }

  @configs = {}

  def self.supported?(payment_system)
    supported_systems.include?(payment_system.to_sym)
  end

  # this is used to return only the available payment systems by their shorthand
  def self.supported_systems
    @supported_sytems ||= SUPPORTED_SYSTEMS.keys
  end

  def self.allowed_options
    @allowed_options ||= SUPPORTED_SYSTEMS.inject({}) do |memo, (system, options)|
      memo.merge!(system => options[:allowed_options])
    end
  end

  def self.config(&block)
    @configs = Configurator.make_configs(supported_systems, allowed_options, &block)
  end

  def self.config_for(payment_system)
    return @configs[payment_system] if @configs.key? payment_system

    allowed_options = SUPPORTED_SYSTEMS[payment_system][:allowed_options]
    Models::Config.create(allowed_options) do |c|
      allowed_options.each do |option|
        c.send option, nil
      end
    end
  end

  def self.using(payment_system)
    unless SUPPORTED_SYSTEMS.key?(payment_system)
      raise UnsupportedPaymentSystem, "Trying to use unsupported payment system #{ payment_system  }"
    end

    PaymentSystem.new(SUPPORTED_SYSTEMS[payment_system][:module], config_for(payment_system)).tap do |ps|
      yield ps if block_given?
    end
  end

  class UnsupportedPaymentSystem < NameError; end
  class UnsupportedConfigurationOption < NameError; end
end
