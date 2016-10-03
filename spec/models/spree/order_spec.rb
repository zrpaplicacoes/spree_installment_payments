require 'rails_helper'

describe Spree::Order do

  subject { Spree::Order }

  it 'has a has_installments property' do
    expect(subject.new.respond_to? :has_installments).to be_truthy
  end

  it 'sets has_installments to false' do
    expect(subject.new.has_installments).to be_falsy
  end

  describe '#set_installments' do

	  context 'when order without installments' do
      let(:order) { build(:order, total: 100,
        payments: [ build(:payment, interest: 0.01, installments: 1) ],
      )}

	  	it 'returns false' do
	  		expect(order.set_installments).to be_falsy
	  	end

      it 'displays total without interest' do
        expect(order.display_total_with_interest).to eq "$100.00"
      end

      it 'displays installments with interests as empty' do
        expect(order.display_total_with_interest).to eq ""
      end
	  end

	  context 'when order with installments' do
      let(:order_in_6_installments) { build(:order, total: 100,
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
