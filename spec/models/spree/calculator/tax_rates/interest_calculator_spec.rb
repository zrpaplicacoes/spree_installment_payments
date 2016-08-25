require 'rails_helper'

describe Spree::Calculator::TaxRates::InterestCalculator do
  subject { Spree::Calculator::TaxRates::InterestCalculator.new }

  # define zone
  let!(:zone) {
    create(:global_zone, max_number_of_installments: 12)
  }

  # define zone interests
  # Applies a interest of 5 % if the number of installments is between 3 to 6 months
  let!(:zone_interest_from_3_to_6) {
    create(:zone_interest, zone: zone, start_number_of_installments: 3, end_number_of_installments: 6, interest: 0.05)
  }

  # Applies a interest of 10 % if the number of installments is between 7 to 12 months
  let!(:zone_interest_from_7_to_12) {
    create(:zone_interest, zone: zone, start_number_of_installments: 7, end_number_of_installments: 12, interest: 0.1)
  }

  it 'has a description for the class' do
    expect(Spree::Calculator::TaxRates::InterestCalculator).to respond_to(:description)
  end

  context "#compute" do
    context 'non-installment order' do
      let(:non_installment_order) {
        order = create(:order, has_installments: false)
      }

      it 'returns 0.0' do
        expect(subject.compute(non_installment_order)).to eq 0.0
      end
    end

    context 'installment order from 3 to 6 months' do
      let(:installment_order_from_3_to_6) {
        order = create(:order_with_line_items, has_installments: true, number_of_installments: 5)
        order.billing_address.country.zones << Spree::Zone.first
        order
      }

      it 'returns the order value * 0.05 ' do
        expect(subject.compute(installment_order_from_3_to_6)).to eq(installment_order_from_3_to_6.item_total * 0.05)
      end

    end

    context 'installment order from 7 to 12 months' do
      let(:installment_order_from_7_to_12) {
        order = create(:order, has_installments: true, number_of_installments: 10)
        order.billing_address.country.zones << Spree::Zone.first
        order
      }

      it 'returns the order value * 0.1' do
        expect(subject.compute(installment_order_from_7_to_12)).to eq(installment_order_from_7_to_12.item_total * 0.1)
      end
    end

  end

  context '#available?' do
    let(:installment_order) {
      order = create(:order, has_installments: true, number_of_installments: 6)
      order.billing_address.country.zones << Spree::Zone.first
      order
    }

    let(:non_installment_order) {
      order = create(:order, has_installments: false)
      order.billing_address.country.zones << Spree::Zone.first
      order
    }

    it 'should return true to an installment order' do
      expect(subject.available?(installment_order)).to be_truthy
    end

    it 'should return false to a non-installment order' do
      expect(subject.available?(non_installment_order)).to be_falsy
    end
  end

end
