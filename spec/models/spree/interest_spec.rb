require 'rails_helper'

describe Spree::Interest do

  subject { Spree::Interest }

  it 'belongs to a payment method' do
    expect(subject.new.respond_to? :payment_method).to be_truthy
  end

  context 'same payment method' do

    let(:payment_method) { create(:credit_card_with_installments) }

    it 'does not allow an overlapping range ' do
      expect  {
        create(:interest, number_of_installments: 3, payment_method: payment_method )
      }.to change(subject, :count).by 1

      expect(build(:interest, payment_method: payment_method, number_of_installments: 3).valid?).to be_falsy
    end

    it 'does not allow a negative number of installments' do
      interest = build(:interest, payment_method: payment_method, number_of_installments: -1)
      expect(interest.valid?).to be_falsy
    end

    it 'does not allow a zero number of installments' do
      interest = build(:interest, payment_method: payment_method, number_of_installments: 0)
      expect(interest.valid?).to be_falsy
    end

    it 'allows interests values between [0,1] only' do
      expect(build(:interest, payment_method: payment_method, value: -0.01).valid?).to be_falsy
      expect(build(:interest, payment_method: payment_method, value:  0.00).valid?).to be_truthy
      expect(build(:interest, payment_method: payment_method, value:  0.05).valid?).to be_truthy
      expect(build(:interest, payment_method: payment_method, value:  1.00).valid?).to be_truthy
      expect(build(:interest, payment_method: payment_method, value:  1.01).valid?).to be_falsy
    end
  end

  context 'different payment methods' do
    let(:credit_card_1) { create(:credit_card_with_installments, name: "CC1", max_number_of_installments: 12) }
    let(:credit_card_2) { create(:credit_card_with_installments, name: "CC2", max_number_of_installments: 18) }

    it 'allows overlapping number of installments' do
      create(:interest, payment_method: credit_card_1, number_of_installments: 3, value: 0.05)

      expect {
        create(:interest, payment_method: credit_card_2, number_of_installments: 3, value: 0.1)
      }.to change(subject, :count).by 1
    end

  end
end
