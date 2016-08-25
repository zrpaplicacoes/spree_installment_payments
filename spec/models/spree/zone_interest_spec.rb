require 'rails_helper'

describe 'Spree::ZoneInterest' do
  subject { Spree::ZoneInterest }

  it 'belongs to zone' do
    expect(subject.new.respond_to? :zone).to be_truthy
  end

  context 'same zone' do
    let(:zone) { create(:global_zone, max_number_of_installments: 12) }
    it 'does not allow an overlapping range ' do
      expect  {
        create(:zone_interest, start_number_of_installments: 3, end_number_of_installments: 6, zone: zone )
      }.to change(subject, :count).by 1

      # expect(build(:zone_interest, zone: zone, start_number_of_installments: 2, end_number_of_installments: 3).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 3, end_number_of_installments: 5).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 3, end_number_of_installments: 6).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 4, end_number_of_installments: 6).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 4, end_number_of_installments: 10).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 6, end_number_of_installments: 7).valid?).to be_falsy
    end

    it 'does not allow an invalid range' do
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 1, end_number_of_installments: 1).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 20, end_number_of_installments: 1).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, start_number_of_installments: 20, end_number_of_installments: 20).valid?).to be_falsy
    end

    it 'does not allow an interval that exceeds the zone limit' do
      interest = build(:zone_interest, zone: zone, start_number_of_installments: 3, end_number_of_installments: 13)
      expect(interest.valid?).to be_falsy
      expect(interest.errors.messages[:end_number_of_installments]).to match_array ["13 overflows the established limit of 12"]
    end

    it 'allows interests between 0 (non-inclusive) and 1 (inclusive) only' do
      expect(build(:zone_interest, zone: zone, interest: 0).valid?).to be_falsy
      expect(build(:zone_interest, zone: zone, interest: 0.05).valid?).to be_truthy
      expect(build(:zone_interest, zone: zone, interest: 1).valid?).to be_truthy
      expect(build(:zone_interest, zone: zone, interest: 1.01).valid?).to be_falsy
    end
  end

  context 'different zones' do
    let(:zone_1) { create(:zone, name: "Zone 1", max_number_of_installments: 12) }
    let(:zone_2) { create(:zone, name: "Zone 2", max_number_of_installments: 18) }

    it 'allows overlapping ranges' do
      create(:zone_interest, zone: zone_1, start_number_of_installments: 3, end_number_of_installments: 6, interest: 0.05)
      expect {
        create(:zone_interest, zone: zone_2, start_number_of_installments: 3, end_number_of_installments: 6, interest: 0.05)
      }.to change(subject, :count).by 1
    end
  end
end
