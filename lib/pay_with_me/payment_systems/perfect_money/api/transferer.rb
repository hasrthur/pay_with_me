# frozen_string_literal: true

module PayWithMe
  module PaymentSystems
    module PerfectMoney
      module Api
        class Transferer
          ENDPOINT = 'https://perfectmoney.is/acct/confirm.asp'
          MAPPING = {
            'Payer_Account' => :payer_account,
            'Payee_Account' => :payee_account,
            'Payee_Account_Name' => :payee_account_name,
            'PAYMENT_AMOUNT' => :amount,
            'PAYMENT_BATCH_NUM' => :transaction_id,
            'PAYMENT_ID' => :payment_id,
            'code' => :code,
            'Period' => :period
          }.freeze

          def initialize(config)
            @additional_params = {}
            @config = config
          end

          def transfer(to: nil,
                       from: @config.payer,
                       amount: 0.0,
                       payment_id: nil,
                       memo: nil,
                       code: nil,
                       period: nil)

            @nokogiri_doc = nil
            @additional_params = {} # clear params in case this object is used to pay e.g. in loop
            @additional_params.merge!(Payer_Account: from,
                                      Payee_Account: to,
                                      Amount: amount,
                                      Memo: memo,
                                      PAYMENT_ID: payment_id,
                                      code: code,
                                      Period: period)

            build_model
          end

          private

          def build_model
            Models::Transfer.new do |t|
              if error = nokogiri_doc.at_xpath('//input[@name="ERROR"]/@value')
                t.error! error.value
              else
                nokogiri_doc.xpath('//input').each do |input|
                  translated_name = MAPPING[input.attributes['name'].value]
                  next unless translated_name

                  value = input.attributes['value'].value
                  value = value.to_f if translated_name == :amount

                  t.send "#{translated_name}!", value
                end
              end
            end
          end

          def response
            return @response if defined? @response

            uri = URI(ENDPOINT)
            Net::HTTP.post_form(uri, params)
          end

          def params
            {
              AccountID: @config.account_id,
              PassPhrase: @config.password
            }.merge!(@additional_params)
          end

          def nokogiri_doc
            @nokogiri_doc ||= Nokogiri::HTML(response.body)
          end
        end
      end
    end
  end
end
