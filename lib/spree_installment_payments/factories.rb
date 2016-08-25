FactoryGirl.define do

  # zone_interest

  factory :zone_interest, class: Spree::ZoneInterest do
    start_number_of_installments 4
    end_number_of_installments 10
    interest 0.0199 # 1.99%
    spree_zone_id { create(:zone ) }
  end

end
