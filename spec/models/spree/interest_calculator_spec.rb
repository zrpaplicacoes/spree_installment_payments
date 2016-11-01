describe Spree::InterestCalculator do
  subject { Spree::InterestCalculator }

  describe "#compute" do
    describe "when computable is nil" do
      let(:computable) { nil }

      it 'returns zero' do
        expect(subject.new(computable).compute.zero?).to be_truthy
      end
    end

    describe "when computable respond_to #interest_adjustment" do
      let(:computable) { create(:order_with_totals) }

      it 'returns the total amount multiplied by the interest adjustment' do
        expect(subject.new(computable).compute).to eq 0.1
      end
    end

  end
end