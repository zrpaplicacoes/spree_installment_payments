require 'rails_helper'

describe 'Spree::ZoneInterest' do
  subject { Spree::ZoneInterest }

  it 'belongs to zone' do
    expect(subject.new.respond_to? :zone).to be_truthy
  end

  context 'same zone' do
    let(:zone) { create(:global_zone) }
    it 'does not allow an overlapping range ' do
      expect  {
        create(:zone_interest, start_number_of_installments: 3, end_number_of_installments: 6, zone: zone )
      }.to change(subject, :count).by 1

      expect(build(:zone_interest, zone: zone, start_number_of_installments: 2, end_number_of_installments: 3).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 3, end_number_of_installments: 5).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 3, end_number_of_installments: 6).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 4, end_number_of_installments: 6).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 4, end_number_of_installments: 10).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 6, end_number_of_installments: 7).valid?).to be_falsy
    end

    it 'allows interests between 0 (non-inclusive) and 1 (inclusive) only' do
      expect(build(:zone_interest, zone: zone, interest: 0).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, interest: 0.05).valid?).to be_truthy
      expect(build(:zone_interest, zone: zone, interest: 1).valid?).to be_truthy
      expect(build(:zone_interest, zone: zone, interest: 1.01).valid?).to be_falsy
    end

  end
end
