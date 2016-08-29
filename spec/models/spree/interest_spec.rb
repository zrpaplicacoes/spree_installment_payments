describe 'Spree::Interest' do
  subject { Spree::Interest }

  let(:credit_card) { create(:credit_card_with_installments) }
  let(:check) { create(:check_without_installments) }

  context '#applicable?' do
    context 'order with non-installment payment method' do
      let(:payment) { create(:payment, payment_method: check) }
      let(:order) { create(:order_with_line_items, payments: [payment] ) }

      it 'is false' do
        interest = subject.new order: order
        expect(interest.applicable?).to be_falsy
      end

    end

    context 'order with installment payment method' do
      let(:payment) { create(:payment, payment_method: credit_card, installments: 3)}
      let(:order) { create(:order_with_line_items, payments: [payment]) }

      it 'is true' do
        interest = subject.new order: order
        expect(interest.applicable?).to be_truthy
      end

    end

  end

  context '#retrieve' do
    let(:payment) { create(:payment, payment_method: credit_card, installments: 3) }
    let(:order) { create(:order_with_line_items, payments: [payment]) }

    it 'returns the best interest associated with an order' do
      interest = subject.new order: order
      expect(interest.retrieve).to eq 0.0
    end

  end


end
