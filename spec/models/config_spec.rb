describe PayWithMe::Models::Config do
  let(:config_hash) { {option_1: 'option_1'} }

  subject(:config) { described_class.new(config_hash) }

  it 'can be created with the help of block' do
    config = described_class.create %i( option_2 ) do |c|
      c.option_2 'option_2'
    end

    expect(config.option_2).to eq 'option_2'
  end

  it 'retrieves the provided options' do
    expect(config.option_1).to eq config_hash[:option_1]
  end

  it 'behaves as a normal object when unsupported options is retrieved' do
    expect { config.unsupported_option }.to raise_error NoMethodError, /unsupported_option/
  end
end