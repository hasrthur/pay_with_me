require_relative 'pay_with_me/version'

module PayWithMe
  # key here is the shorthand which will be used by users of the gem
  # value is the module name for the payment system
  SUPPORTED_SYSTEMS = {
      :perfect_money => :PerfectMoney
  }

  def self.supported?(payment_system)
    supported_systems.include?(payment_system.to_sym)
  end

  # this is used to return only the available payment systems by their shorthand
  def self.supported_systems
    @supported_sytems ||= SUPPORTED_SYSTEMS.keys
  end
end
