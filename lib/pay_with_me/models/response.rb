module PayWithMe
  module Models
    class Response
      attr_accessor :error

      def succeed?
        error.nil?.tap do |success|
          yield self if success && block_given?
        end
      end
      alias_method :ok?, :succeed?

      def failed?
        (!succeed?).tap do |fail|
          yield self if fail && block_given?
        end
      end
    end
  end
end