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

end
