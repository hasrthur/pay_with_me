# frozen_string_literal: true

module PayWithMe
  module PaymentSystems
    module PerfectMoney
      module Models
        class Transfer < PayWithMe::Models::Transfer
          %i[
            payee_account_name
            code
          ].each do |attr|
            define_attr_methods_for attr
          end
        end
      end
    end
  end
end
