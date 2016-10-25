#encoding: utf-8

describe Spree::Payment do
	subject { Spree::Payment }

	it 'does not allow a negative interest' do
		payment = build(:payment, interest: -0.01)
		expect(payment.valid?).to be_falsy
	end

	it 'does not allow a negative or zero installments' do
		payment = build(:payment, installments: -1)
		expect(payment.valid?).to be_falsy
		payment = build(:payment, installments: 0)
		expect(payment.valid?).to be_falsy
	end

	it 'sets by default the installments as 1' do
		expect(subject.new.installments).to eq 1
	end

	it 'sets by default the charge interest property as true' do
		expect(subject.new.charge_interest).to be_truthy
	end

	context "when gateway_options" do
		let(:order) { create(:completed_order_with_totals) }
    let!(:payment) do
      create(
        :payment,
        order: order,
        amount: order.total,
        state: "processing",
        installments: 6
      )
    end
    let(:payment_method) { create(:credit_card_with_installments, :with_charge_interest) }
    let!(:interest) { create(:interest, payment_method: payment_method) }

    before :each do
    	order
    	payment.update(payment_method: payment_method)
    end

		it 'sets a hash using Spree::Payment::GatewayOptions with installments and charge interest' do
			gateway_options = Spree::Payment::GatewayOptions.new(payment)
			gateway_options_hash = gateway_options.to_hash
			expect(payment.interest_adjustment > 1).to be_truthy
			expect(gateway_options_hash[:installments]).to eq 6
			expect(gateway_options_hash[:chargeInterest]).to be_truthy
			expect(gateway_options_hash[:subtotal].round(2).to_s).to eq "1060.89"
			expect(payment.amount.round(2).to_s).to eq "116.7"
		end

	end


end
