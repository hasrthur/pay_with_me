describe PayWithMe::Models::Transfer do
  let(:payer_account)  { double }
  let(:payee_account)  { double }
  let(:payment_amount) { double }
  let(:transaction_id) { double }
  let(:payment_id)     { double }

  subject(:transfer) do
    described_class.new do |t|
      t.payer_account!  payer_account
      t.payee_account!  payee_account
      t.payment_amount! payment_amount
      t.transaction_id! transaction_id
      t.payment_id!     payment_id
    end
  end

  it 'sets correctly all the attributes' do
    expect(transfer.payer_account).to  eq payer_account
    expect(transfer.payee_account).to  eq payee_account
    expect(transfer.payment_amount).to eq payment_amount
    expect(transfer.transaction_id).to eq transaction_id
    expect(transfer.payment_id).to     eq payment_id
  end
end