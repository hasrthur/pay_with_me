module PayWithMe
  module PaymentSystems
    module PerfectMoney
      module Api
        class BalanceRetriever
          ENDPOINT = 'https://perfectmoney.is/acct/balance.asp'.freeze

          def initialize(config)
            @config = config
          end

          def retrieve
            Models::Balance.new do |b|
              if error = nokogiri_doc.at_xpath('//input[@name="ERROR"]/@value')
                b.error! error.value
              else
                nokogiri_doc.xpath('//input').each do |input|
                  account = input.attributes['name'].value
                  balance = input.attributes['value'].value.to_f
                  b.account account, with_balance: balance
                end
              end
            end
          end

          private

          def response
            return @response if defined? @response

            uri = URI(ENDPOINT)
            uri.query = URI.encode_www_form(params)
            @response =  Net::HTTP.get_response(uri)
          end

          def params
            {
                :AccountID  => @config.account_id,
                :PassPhrase => @config.password
            }
          end

          def nokogiri_doc
            @nokogiri_doc ||= Nokogiri::HTML(response.body)
          end
        end
      end
    end
  end
end