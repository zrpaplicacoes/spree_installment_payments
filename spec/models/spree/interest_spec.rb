describe 'Spree::Interest' do
  subject { Spree::Interest }


  context '#retrieve' do

    before :each do
      @order =  create(:order_with_line_items, state: :payment)
      @zone = create(:zone, max_number_of_installments: 12)
      @zone_interest = create(:zone_interest, zone: @zone)

      @order.billing_address.state.zones << @zone

      @credit_card = create(:credit_card_with_installments, :with_charge_interest)
      @check = create(:check_without_installments)
      @payment = create(:payment, payment_method: @credit_card, installments: 3, state: :checkout)

      @order.payments << @payment
    end


    it 'returns the best interest associated with an order' do
      interest = subject.new order: @order, payment_method: @credit_card
      expect(interest.retrieve).to eq 0.0
    end

  end

end
