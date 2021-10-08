# frozen_string_literal: true

RSpec.describe 'Configuration of Perfect money' do
  let(:account_id) { 'account_id' }
  let(:password) { 'password' }
  let(:payer) { 'payer' }
  let(:alternate_password) { 'alternate_password' }

  it 'allows to configure payer, account_id, password, sci_salt' do
    PayWithMe.config do |c|
      c.configure :perfect_money do |pm|
        pm.account_id account_id
        pm.password password
        pm.payer payer
        pm.sci_salt alternate_password
      end
    end

    PayWithMe.config_for(:perfect_money).tap do |c|
      expect(c.account_id).to eq account_id
      expect(c.password).to eq password
      expect(c.payer).to eq payer
      expect(c.sci_salt).to eq alternate_password
    end
  end
end
