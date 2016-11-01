module Spree
  module PaymentDecorator

    def amount
      super * interest_adjustment
    end

    def interest_adjustment
      set_interest if state == "processing"
      has_interest? ? (1.0 + interest)**installments : 1.0
    end

    def set_interest
      raise UnavailablePaymentMethod unless payment_method.present?
      interest = payment_method.interest_value_for(installments)
    end

    def has_interest?
      interest.present? && !interest.zero?
    end
  end

  Payment.class_eval do
    class UnavailablePaymentMethod < StandardError; end
    prepend Spree::PaymentDecorator

    validates :interest, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :installments, numericality: { greater_than_or_equal_to: 1 }

  end

end