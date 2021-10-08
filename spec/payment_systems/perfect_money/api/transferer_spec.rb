# frozen_string_literal: true

describe PayWithMe::PaymentSystems::PerfectMoney::Api::Transferer do
  subject(:transfer) { PayWithMe.using(:perfect_money).transfer(options) }

  context 'valid request', vcr: { cassette_name: 'perfect_money/transfer/valid' } do
    let(:options) do
      {
        to: 'U9999999',
        from: 'U9999999',
        amount: 0.01,
        payment_id: 42,
        memo: 'somememo'
      }
    end

    it { is_expected.to be_ok }

    it 'populates the model' do
      expect(transfer.payer_account).to eq options[:from]
      expect(transfer.payee_account).to eq options[:to]
      expect(transfer.amount).to eq options[:amount]
      expect(transfer.payment_id.to_i).to eq options[:payment_id]

      expect(transfer.payee_account_name).not_to be_empty
      expect(transfer.transaction_id).not_to be_nil

      expect(transfer.code).to eq options[:code]
    end
  end

  context 'invalid request', vcr: { cassette_name: 'perfect_money/transfer/invalid' } do
    let(:options) do
      {
        to: 42,
        from: 'U9997283',
        amount: -442,
        payment_id: 4342,
        memo: 'Some memo'
      }
    end

    it { is_expected.to be_failed }

    it 'has errors' do
      expect(transfer.error).to eq 'Invalid Amount'
    end
  end
end
