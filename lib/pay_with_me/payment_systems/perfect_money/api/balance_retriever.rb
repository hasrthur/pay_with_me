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
            PayWithMe::Models::Balance.new do |b|
              with_nokogiri_doc(response) do |nokogiri_doc|
                if (error = nokogiri_doc.at_xpath('//input[@name="ERROR"]/@value'))
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
          end

          private

          def response
            Net::HTTP.get_response(URI(ENDPOINT).tap { |uri| uri.query = URI.encode_www_form(params) })
          end

          def params
            {
                :AccountID  => @config.account_id,
                :PassPhrase => @config.password
            }
          end

          def with_nokogiri_doc(response)
            yield Nokogiri::HTML(response.body)
          end
        end
      end
    end
  end
end
