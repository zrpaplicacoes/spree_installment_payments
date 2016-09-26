FactoryGirl.define do
  factory :zone_interest, class: Spree::ZoneInterest do
    interest 0.005 # 0.5%
    start_number_of_installments 2
    end_number_of_installments 8
    zone { create(:zone, max_number_of_installments: 8) }

    trait :zone_interest_2_4 do
      start_number_of_installments 2
      end_number_of_installments 4
      interest 0.0099 # 0.99%
    end

    trait :zone_interest_5_9 do
      start_number_of_installments 5
      end_number_of_installments 9
      interest 0.0199 # 1.99%
    end

    trait :zone_interest_10_12 do
      start_number_of_installments 10
      end_number_of_installments 12
      interest 0.0299 # 2.99%
    end
  end



end
