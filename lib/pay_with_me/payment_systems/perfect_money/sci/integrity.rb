require 'digest'

module PayWithMe
  module PaymentSystems
    module PerfectMoney
      module Sci
        class Integrity
          def initialize(config)
            @config = config
          end

          def check(params)
            params = params.reduce({}) {|memo, (k, v)| memo.merge!(k.to_sym => v) }
            params[:PAYMENT_ID] ||= 'NULL'

            params[:sci_salt] = hash_string(params[:sci_salt] || params['sci_salt'] || @config.sci_salt)

            string = build_string_from params
            
            PayWithMe::Models::IntegrityCheck.new(hash_string(string) == params.fetch(:V2_HASH))
          end
          
          private
          
          def build_string_from(params)
            Array.new(8, '%s').join(':') % params.values_at(:PAYMENT_ID, :PAYEE_ACCOUNT, :PAYMENT_AMOUNT,
                                                            :PAYMENT_UNITS, :PAYMENT_BATCH_NUM, :PAYER_ACCOUNT,
                                                            :sci_salt, :TIMESTAMPGMT)
          end
          
          def hash_string(string)
            Digest::MD5.hexdigest(string).upcase!
          end
        end
      end
    end
  end
end