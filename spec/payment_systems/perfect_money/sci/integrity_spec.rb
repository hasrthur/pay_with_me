RSpec.describe PayWithMe::PaymentSystems::PerfectMoney::Sci::Integrity do
  before do
    PayWithMe.config do |c|
      c.configure :perfect_money do |pm|
        pm.sci_salt alternate_password
      end
    end
  end
  
  let(:alternate_password) { 'm9O2768ZuMFVvWphuPJVJJfRX' }
  
  context 'when payment_id is provided' do
    let(:params) do
      {
        "PAYEE_ACCOUNT"     => "U9997283",
        "PAYMENT_ID"        => "payment_id",
        "PAYMENT_AMOUNT"    => "0.01",
        "PAYMENT_UNITS"     => "USD",
        "PAYMENT_BATCH_NUM" => "97063086",
        "PAYER_ACCOUNT"     => "U9997283",
        "TIMESTAMPGMT"      => "1438797966",
        "V2_HASH"           => "809D383B09798F1B86E50D3472A56CBF",
        "BAGGAGE_FIELDS"    => ""
      }
    end
    
    it 'verifies integrity for valid data' do
      expect(PayWithMe.using(:perfect_money).check_integrity_for(params)).to be_valid
    end
  end
  
  context 'when payment_id is not provided' do
    let(:params) do
      {
        "PAYEE_ACCOUNT"     => "U9997283",
        "PAYMENT_AMOUNT"    => "0.01",
        "PAYMENT_UNITS"     => "USD",
        "PAYMENT_BATCH_NUM" => "97066763",
        "PAYER_ACCOUNT"     => "U9997283",
        "TIMESTAMPGMT"      => "1438800349",
        "V2_HASH"           => "C4B4BE909864085B2BA4355B8650FE43",
        "field1"            => "value_1",
        "BAGGAGE_FIELDS"    => "field1"
      }
    end
    
    it 'verifies integrity for valid data' do
      expect(PayWithMe.using(:perfect_money).check_integrity_for(params)).to be_valid
    end
  end
end