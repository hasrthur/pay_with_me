# frozen_string_literal: true

describe PayWithMe::PaymentSystems::PerfectMoney::Api::BalanceRetriever do
  subject(:balance) { PayWithMe.using(:perfect_money).balance }

  context 'valid request', vcr: { cassette_name: 'perfect_money/balance/valid' } do
    it { is_expected.to be_ok }

    it 'returns correct balances' do
      expect(balance.balance_for('U9999999')).to eq 10.0
      expect(balance.balance_for('E9999999')).to eq 8.57
      expect(balance.balance_for('G9999999')).to eq 7.13
    end
  end

  context 'invalid request', vcr: { cassette_name: 'perfect_money/balance/invalid' } do
    it { is_expected.to be_failed }

    it 'has errors' do
      expect(balance.error).to eq 'Can not login with passed AccountID and PassPhrase'
    end
  end
end
