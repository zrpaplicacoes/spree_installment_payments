FactoryGirl.define do
  factory :zone_interest do
    start_number_of_installments 4
    end_number_of_installments 10
    interest 0.0199 # 1.99%
    zone { create(:zone, max_number_of_installments: 12 ) }
  end
end
