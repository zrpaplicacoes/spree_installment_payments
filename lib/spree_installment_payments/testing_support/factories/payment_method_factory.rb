FactoryGirl.define do
  # check
  factory :check_without_installments, class: Spree::PaymentMethod::Check  do
    name 'Check'
    accept_installments false
  end

  # credit card
  factory :credit_card_with_installments, class: Spree::Gateway::Bogus  do
    name 'Credit Card'
    accept_installments true
    max_number_of_installments 12
    base_value 100

  end

end
