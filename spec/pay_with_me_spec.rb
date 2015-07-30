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
end