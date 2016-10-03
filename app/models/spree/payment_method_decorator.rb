module Spree

  PaymentMethod.class_eval do
    has_many :interests, dependent: :destroy
  end

end
