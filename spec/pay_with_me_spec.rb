describe PayWithMe do
  describe '.supported?' do
    it 'returns true for Perfect Money' do
      expect(described_class.supported?(:perfect_money)).to be true
    end

    it 'works with string as well' do
      expect(described_class.supported?('perfect_money')).to be true
    end

    it 'does not work for unsupported systems' do
      expect(described_class.supported?(:liberty_reserve)).to be false
    end
  end

  describe '.config' do
    it 'allows to configure the gem with the help of code' do
      PayWithMe.config do
        configure :perfect_money do
          account_id 42
          password 'password'
        end
      end

      PayWithMe.config_for(:perfect_money).tap do |config|
        expect(config.account_id).to eq 42
        expect(config.password).to eq 'password'
      end
    end

    it 'throws exception when trying to configure unsupported payment system' do
      expect do
        PayWithMe.config do
          configure :liberty_reserve do
            account_id 42
          end
        end
      end.to raise_error PayWithMe::UnsupportedPaymentSystem, /liberty_reserve/
    end

    it 'throws exception when trying to set property which is not supported' do
      expect do
        PayWithMe.config do
          configure :perfect_money do
            dumb_option 42
          end
        end
      end.to raise_error PayWithMe::UnsupportedConfigurationOption, /dumb_option/
    end
  end

  fdescribe '.using' do
    it 'raises error if trying to use unsupported payment system' do
      expect do
        PayWithMe.using :liberty_reserve
      end.to raise_error PayWithMe::UnsupportedPaymentSystem, /liberty_reserve/
    end

    it 'returns the payment system object' do
      expect(PayWithMe.using(:perfect_money)).to be_kind_of PayWithMe::PaymentSystems::Base
    end

    it 'allows to use block with payment system passed as argument' do
      expect {|b| PayWithMe.using(:perfect_money, &b) }.to yield_with_args PayWithMe::PaymentSystems::PerfectMoney
    end
  end
end