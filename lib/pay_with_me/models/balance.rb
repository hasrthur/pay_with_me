# frozen_string_literal: true

module PayWithMe
  module Models
    class Balance < Response
      def initialize
        @accounts = {}
        yield self
      end

      def accounts
        @accounts ||= {}
        @accounts.dup
      end

      # returns nil if the requested account doesn't exist
      def balance_for(account)
        @accounts[account]
      end

      # returns the balance of the first account
      # useful when payment system has only one account
      def balance
        @accounts.values.first
      end

      def account(account_number, with_balance: 0.0)
        @accounts[account_number] = with_balance
      end
    end
  end
end
