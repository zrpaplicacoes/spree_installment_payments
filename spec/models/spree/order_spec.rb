require 'rails_helper'

describe Spree::Order do

  subject { Spree::Order }

  it 'has a has_installments property' do
    expect(subject.new.respond_to? :has_installments).to be_truthy
  end

  it 'sets has_installments to false' do
    expect(subject.new.has_installments).to be_falsy
  end

  describe '#valid_installments' do
  	let(:valid_payment) { create(:payment, payment_method: create(:credit_card_with_installments))}
  	let(:invalid_payment) { create(:payment, payment_method: create(:credit_card_with_installments, max_number_of_installments: 1))}

	  describe 'if the installment is not valid' do
	    let(:order) { create(:order_with_line_items)}

    	before :each do
	  		order.billing_address = create(:address)
	  		order.billing_address.state.zones << create(:zone, max_number_of_installments: 8, base_value: 40)
	  		order.billing_address.state.save
	  		order.reload
        order.payment = invalid_payment
        order.payment.save
	  	end

	  	it 'returns nil' do
	  		expect(order.valid_installments?).to be_nil
	  	end
	  end

	  describe 'if my installment in this order is valid' do
	    let(:order) { create(:order, payment: valid_payment)}
	    it 'returns the order instance' do
	  		expect(order.valid_installments?).to be_an_instance_of(Spree::Order)
	    end
	  end

  end


end
