describe PayWithMe::Models::Balance do
  let(:account_1) { 'account_1' }
  let(:balance_1) { 100.0 }
  let(:account_2) { 'account_2' }
  let(:balance_2) { 142.0 }

  subject(:balance) do
    acc_1, bal_1 = account_1, balance_1
    acc_2, bal_2 = account_2, balance_2
    described_class.new do
      account acc_1, with_balance: bal_1
      account acc_2, with_balance: bal_2
    end
  end

  it 'sets the accounts and balances correctly' do
    expect(balance.accounts).to have_key account_1
    expect(balance.accounts[account_1]).to eq balance_1

    expect(balance.accounts).to have_key account_2
    expect(balance.accounts[account_2]).to eq balance_2
  end

  describe '#accounts' do
    it 'can return the hash with all the accounts which does not impact on the model' do
      balance.accounts[account_1] = balance_1 + 42
      expect(balance.accounts[account_1]).to eq balance_1
    end
  end

  describe '#balance_for' do
    it 'returns balance for specified account' do
      expect(balance.balance_for(account_1)).to eq balance_1
      expect(balance.balance_for(account_2)).to eq balance_2
    end
  end

  describe '#balance' do
    it 'returns the balance of the first account' do
      expect(balance.balance).to eq balance_1
    end
  end
end