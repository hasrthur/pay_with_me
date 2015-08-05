module PayWithMe
  class PaymentSystem
    def initialize(payment_system_scope, config)
      @payment_system_scope = payment_system_scope
      @config = config
    end

    def balance
      use_api!('BalanceRetriever').retrieve
    end

    def transfer(options = {})
      use_api!('Transferer').transfer(options)
    end
    
    def check_integrity_for(params)
      use_sci!('Integrity').check(params)
    end

    private

    def use_api!(name)
      get_obj(name, :api)
    end
    
    def use_sci!(name)
      get_obj(name, :sci)
    end
    
    def get_obj(name, type = :api)
      path = "PayWithMe::PaymentSystems::#{ @payment_system_scope }::#{ type.to_s.capitalize! }::#{ name }"
      Object.const_get(path).new(@config)
    end
  end
end
