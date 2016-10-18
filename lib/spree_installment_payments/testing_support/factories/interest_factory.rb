FactoryGirl.define do
  factory :interest, class: Spree::Interest do
    sequence(:name) { |n| "Interest #{n}"}
    number_of_installments 1
    value 0.0099
  end
end