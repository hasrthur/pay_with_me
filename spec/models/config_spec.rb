describe PayWithMe::Models::Config do
  subject(:config) do
    described_class.create %i( option_1 ) do |c|
      c.option_1 'option_1'
    end
  end

  it 'retrieves the provided options' do
    expect(config.option_1).to eq 'option_1'
  end

  it 'behaves as a normal object when unsupported options is retrieved' do
    expect { config.unsupported_option }.to raise_error NoMethodError, /unsupported_option/
  end
end
