#encoding: utf-8
require 'helpers/zones_helper'

describe Spree::Payment do
	let(:order) { create(:order_with_line_items, line_items_count: 5) }

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
			let(:invalid_payment_method) { create(:credit_card_with_installments) }
			let(:invalid_payment) { build(:payment, order: order, installments: 4, payment_method: invalid_payment_method) }


			describe 'because of the zone does not allow this number of installments' do
				before :each do
			  	set_zone_with_installment_to_order(order, { max_number_of_installments: 1, base_value: 10 })
				end

			  it 'returns false' do
	  			invalid_payment.save

	  			expect(invalid_payment.valid_installments?).to be_falsy
			  end

			  it 'adds the properly error' do
	  			invalid_payment.save

	  			expect(invalid_payment.errors.messages[:installments].present?).to be_truthy
	  			expect(invalid_payment.errors.messages[:installments][0]).to eq("is invalid")
			  end
			end

			describe 'because of base value does not allow to split in this number of installments' do
				before :each do
			  	set_zone_with_installment_to_order(order, { max_number_of_installments: 6, base_value: 10000 })
				end

			  it 'returns false' do
	  			invalid_payment.save

	  			expect(invalid_payment.valid_installments?).to be_falsy
			  end

			  it 'adds the properly error' do
	  			invalid_payment.save

	  			expect(invalid_payment.errors.messages[:installments].present?).to be_truthy
	  			expect(invalid_payment.errors.messages[:installments][0]).to eq("is invalid")
			  end
			end
		end
	end
end
