module PayWithMe
  class PaymentSystem
    def initialize(payment_system_scope, config)
      @payment_system_scope = payment_system_scope
      @config = config
    end

    def balance
      use!('BalanceRetriever').retrieve
    end

    private

    def use!(name)
      path = "PayWithMe::PaymentSystems::#{ @payment_system_scope }::Api::#{ name }"
      Object.const_get(path).new(@config)
    end
  end
end