#encoding: utf-8

def set_zone_with_installment_to_order(order, args = {max_number_of_installments: 8, base_value: 40})
	max_number_of_installments = args[:max_number_of_installments]
	base_value = args[:base_value]

	order.billing_address = create(:address)
	order.billing_address.state.zones << create(:zone, max_number_of_installments: max_number_of_installments, base_value: base_value)
	order.save!

	order.reload
end
