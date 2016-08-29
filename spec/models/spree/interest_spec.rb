describe 'Spree::Interest' do
  subject { Spree::Interest }

  let(:credit_card) { create(:credit_card_with_installments) }
  let(:check) { create(:check_without_installments) }

  context '#retrieve' do
    let(:payment) { create(:payment, payment_method: credit_card, installments: 3) }
    let(:order) { create(:order_with_line_items, payments: [payment]) }

    it 'returns the best interest associated with an order' do
      interest = subject.new order: order
      expect(interest.retrieve).to eq 0.0
    end

  end


end
