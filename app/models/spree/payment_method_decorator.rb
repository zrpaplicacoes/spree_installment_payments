module Spree

  PaymentMethod.class_eval do
    has_many :zone_interests, dependent: :destroy
  end

end
