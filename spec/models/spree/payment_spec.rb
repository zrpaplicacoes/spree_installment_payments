#encoding: utf-8
require 'helpers/zones_helper'

describe Spree::Payment do
	let(:zone_interest) { create(:zone_interest) }
	let(:order) { create(:order_with_line_items) }

	describe "valid_installments?" do
		describe 'if the installment is valid' do
		  it 'returns true' do
		  	set_zone_with_installment_to_order(order, { max_number_of_installments: 6, base_value: 5 })

		  	valid_payment_method = create(:credit_card_with_installments)
				valid_payment = build(:payment, order: order, installments: 4, payment_method: valid_payment_method)
				valid_payment.save

				expect(valid_payment.valid_installments?).to be_truthy
		  end
		end

		describe 'if the installment is not valid' do
		  it 'adds the properly error' do
		  	set_zone_with_installment_to_order(order, { max_number_of_installments: 1, base_value: 10 })

  	  	invalid_payment_method = create(:credit_card_with_installments)
  			valid_payment = build(:payment, order: order, installments: 4, payment_method: invalid_payment_method)
  			valid_payment.save

  			expect(valid_payment.valid_installments?).to be_falsy
		  end
		end
	end
end
