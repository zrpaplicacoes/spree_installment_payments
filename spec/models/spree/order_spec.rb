require 'rails_helper'

describe Spree::Order do
  subject { Spree::Order }

  context "when invalid installments" do
    before :each do
      allow_any_instance_of(Spree::Order).to receive(:valid_installments?).and_return(false)
      @order = subject.new(total: 100)
      @payment_method = create(:credit_card_with_installments)
      @interest = create(:interest, value: 0.01, payment_method: @payment_method, number_of_installments: 3)
      @order.payments << build(:payment, installments: 3, payment_method: @payment_method, amount: 100)
      @order.save_payment_with_installments
    end

    it 'adds an error to the model' do
      expect(@order.errors[:payments]).to match_array ["Invalid number of installments not allowed!"]
    end
  end

  context "when valid installments" do

    before :each do
      allow_any_instance_of(Spree::Order).to receive(:valid_installments?).and_return(true)
      @order = subject.new(total: 100)
      @payment_method = create(:credit_card_with_installments)
      @interest = create(:interest, value: 0.01, payment_method: @payment_method, number_of_installments: 3)
      @order.payments << build(:payment, installments: 3, payment_method: @payment_method, amount: 100)
      @order.save_payment_with_installments
    end

    it 'does not add an error to the model' do
      expect(@order.errors[:payments]).to be_empty
    end

    it 'updates the payment with the payment method specifications' do
      expect(@order.payment.interest).to eq @interest.value
      expect(@order.payment.installments).to eq 3
      # ( 100 * ( 1.01 )**3 )  - 100 => 3.03
      expect(@order.payment.interest_amount).to eq 3.03
    end

    it 'displays total with interest' do
      expect(@order.display_total_with_interest).to eq "$103.03"
    end

    it 'displays total per installment' do
      expect(@order.display_total_per_installment).to eq "$34.34"
    end

  end

end
