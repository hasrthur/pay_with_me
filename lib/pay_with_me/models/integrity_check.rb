# frozen_string_literal: true

module PayWithMe
  module Models
    class IntegrityCheck
      def initialize(valid = false)
        @valid = valid
      end

      def valid?
        !!@valid
      end
    end
  end
end
