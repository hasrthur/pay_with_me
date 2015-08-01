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
      PayWithMe.config do |c|
        c.configure :perfect_money do |pm|
          pm.account_id 42
          pm.password 'password'
        end
      end

      PayWithMe.config_for(:perfect_money).tap do |config|
        expect(config.account_id).to eq 42
        expect(config.password).to eq 'password'
      end
    end

    it 'throws exception when trying to configure unsupported payment system' do
      expect do
        PayWithMe.config do |c|
          c.configure :liberty_reserve do |lr|
            lr.account_id 42
          end
        end
      end.to raise_error PayWithMe::UnsupportedPaymentSystem, /liberty_reserve/
    end

    it 'throws exception when trying to set property which is not supported' do
      expect do
        PayWithMe.config do |c|
          c.configure :perfect_money do |pm|
            pm.dumb_option 42
          end
        end
      end.to raise_error PayWithMe::UnsupportedConfigurationOption, /dumb_option/
    end
  end

  describe '.using' do
    it 'raises error if trying to use unsupported payment system' do
      expect do
        PayWithMe.using :liberty_reserve
      end.to raise_error PayWithMe::UnsupportedPaymentSystem, /liberty_reserve/
    end

    it 'returns the payment system object' do
      expect(PayWithMe.using(:perfect_money)).to be_kind_of PayWithMe::PaymentSystem
    end

    it 'allows to use block with payment system passed as argument' do
      expect {|b| PayWithMe.using(:perfect_money, &b) }.to yield_with_args PayWithMe::PaymentSystem
    end
  end

  describe '.config_path=' do
    context 'valid yaml file' do
      let(:config_path) { File.expand_path('pay_with_me.yaml', File.dirname(__FILE__)) }
      let(:yaml) { YAML.load_file(config_path) }

      it 'sets the config from .yaml file' do
        PayWithMe.config_path = config_path

        PayWithMe.config_for(:perfect_money).tap do |config|
          expect(config.account_id).to eq yaml['perfect_money']['account_id']
          expect(config.password).to eq yaml['perfect_money']['password']
          expect(config.payer).to eq yaml['perfect_money']['payer']
        end
      end
    end

    context 'invalid yaml file' do
      context 'with unsupported payment system' do
        let(:config_path) { File.expand_path('pay_with_me_with_unsupported_payment_system.yaml', File.dirname(__FILE__)) }

        it 'raises UnsupportedPaymentSystem' do
          expect { PayWithMe.config_path = config_path }.to raise_error PayWithMe::UnsupportedPaymentSystem, /liberty_reserve/
        end
      end

      context 'with unsupported config option' do
        let(:config_path) { File.expand_path('pay_with_me_with_unsupported_config_option.yaml', File.dirname(__FILE__)) }

        it 'raises UnsupportedConfigurationOption' do
          expect { PayWithMe.config_path = config_path }.to raise_error PayWithMe::UnsupportedConfigurationOption, /unsupported_option/
        end
      end
    end
  end
end