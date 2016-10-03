require 'rails_helper'

describe Spree::Order do
  subject { Spree::Order }
  let(:valid_installments) { true }
  let(:interest) { 0 }

  before :each do
    allow_any_instance_of(Spree::Payment).to receive(:valid_installments?).and_return(valid_installments)
    allow_any_instance_of(Spree::Order).to receive(:interest).and_return(OpenStruct.new(retrieve: interest))
  end

  it 'has a has_installments property' do
    expect(subject.new.respond_to? :has_installments).to be_truthy
  end

  it 'sets has_installments to false' do
    expect(subject.new.has_installments).to be_falsy
  end

  describe "#display_total_per_installment" do
    before :each do
      order.set_installments
    end

    context "when order without installments" do
      let(:order) { build(:order, total: 100, payments: [ build(:payment, installments: 1, amount: 100) ] )}

      context "with interest" do
        let(:interest) { 0.01 }
        it { expect(order.display_total_per_installment).to eq "$101.00" }
      end

      context "without interest" do
        let(:interest) { 0.0 }
        it { expect(order.display_total_per_installment).to eq "$100.00" }
      end

    end

    context "when order with installments" do
      let(:order) { build(:order, total: 100, payments: [ build(:payment, installments: 6, amount: 100) ] )}

      context "with interest" do
        let(:interest) { 0.01 }
        it { expect(order.display_total_per_installment).to eq "$106.15" }
      end

      context "without interest" do

        it { expect(order.display_total_per_installment).to eq "$100.00" }
      end
    end

  end

  describe "#display_total" do
    before :each do
      order.set_installments
    end

    context "when order without installments" do
      let(:order) { build(:order, total: 100, payments: [ build(:payment, installments: 1, amount: 100) ] )}

      context "with interest" do
        let(:interest) { 0.01 }
        it { expect(order.display_total).to eq "$101.00" }
      end

      context "without interest" do

        it { expect(order.display_total).to eq "$100.00" }
      end

    end

    context "when order with installments" do
      let(:order) { build(:order, total: 100, payments: [ build(:payment, installments: 6, amount: 100) ] )}

      context "with interest" do
        let(:interest) { 0.01 }
        it { expect(order.display_total).to eq "$106.15" }
      end

      context "without interest" do

        it { expect(order.display_total).to eq "$100.00" }
      end
    end

  end

  describe '#set_installments' do
    before :each do
      order.set_installments
    end

	  context 'when order without installments' do
      let(:order) { build(:order, total: 100, payments: [ build(:payment, installments: 1, amount: 100) ] )}

	  	it 'sets order has_installments to false' do
        expect(order.has_installments?).to be_falsy
	  	end

      context "with interest" do
        let(:interest) { 0.01 }

        it 'updates payment interest to interest rounded to 4 decimal places' do
          expect(order.payment.interest.to_s).to eq "0.01"
        end

        it 'updates payment total to eq order total with interest' do
          expect(order.payment.amount.to_s).to eq "101.0"
        end
      end

      context "without interest" do

        it 'sets the payment interest to nil' do
          expect(order.payment.interest.to_s).to eq "0.0"
        end

        it 'does not change the payment total' do
          expect(order.payment.amount.to_s).to eq "100.0"
        end
      end


	  end

	  context 'when order with installments' do
      let(:order) { build(:order, total: 100, payments: [ build(:payment, installments: 6, amount: 100) ] )}

      it 'sets order has_installments to true' do
        expect(order.has_installments?).to be_truthy
      end

      context "with interest" do
        let(:interest) { 0.01 }

        it 'updates payment interest to interest rounded to 4 decimal places' do
          expect(order.payment.interest.to_s).to eq "0.01"
        end

        it 'updates payment total to eq order total with interest' do
          expect(order.payment.amount.to_s).to eq "106.15"
        end
      end

      context "without interest" do

        it 'sets the payment interest to nil' do
          expect(order.payment.interest.to_s).to eq "0.0"
        end

        it 'does not change de payment total' do
          expect(order.payment.amount.to_s).to eq "100.0"
        end
      end
	  end

  end


end
