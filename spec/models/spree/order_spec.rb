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
      let(:order_in_6_installments) { build(:order, total: 100, has_installments: true,
        payments: [ build(:payment, interest: 0.01, installments: 6) ],
      )}

	    let(:order_in_3_installments) { build(:order, total: 100, has_installments: true,
        payments: [ build(:payment, interest: 0.01, installments: 3) ],
      )}

      it 'displays total with compound interest' do
        expect(order_in_6_installments.display_total_with_interest).to eq "$106.15"
        expect(order_in_3_installments.display_total_with_interest).to eq "$103.03"
      end

      it 'displays the amount for each month' do
        expect(order_in_6_installments.display_installment_with_interest).to eq "$17.69"
        expect(order_in_3_installments.display_installment_with_interest).to eq "$34.34"
      end

	  end

  end


end
