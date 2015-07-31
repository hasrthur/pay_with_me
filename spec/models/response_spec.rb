describe PayWithMe::Models::Response do
  let(:response) { Class.new(described_class).new }

  describe '#succeed?' do
    subject { response.succeed? }

    it { is_expected.to be true }

    it 'allows to call block' do
      expect {|b| response.succeed?(&b) }.to yield_with_args(response)
    end

    context '#failed?' do
      subject { response.failed? }

      it { is_expected.to be false }
    end
  end

  describe '#failed?' do
    before { response.error = 'Some error' }
    subject { response.failed? }

    it { is_expected.to be true }

    it 'allows to call block' do
      expect {|b| response.failed?(&b) }.to yield_with_args(response)
    end

    context '#succeed?' do
      subject { response.succeed? }

      it { is_expected.to be false }
    end
  end
end