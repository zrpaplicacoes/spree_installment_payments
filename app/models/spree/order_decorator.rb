module Spree
  Order.class_eval do
    def valid_installments?
      self.update(has_installments: payment.installments > 1) if payment.valid_installments?
    end

    def lock_payment_interest
      payment.update(interest: interest.retrieve.round(4))
    end

    def payment
      self.payments.last
    end

    def display_total_with_interest
      Spree::Money.new(total_with_interest, { currency: currency }).to_s
    end

    def display_installment_with_interest
      Spree::Money.new(total_with_interest / payment.installments, { currency: currency }).to_s
    end

    def interest
      Spree::Interest.new(order: self, payment_method: payment.payment_method)
    end

    private

    def total_with_interest
      total * compound_interest
    end

    def compound_interest
      (1 + payment.interest)**payment.installments
    end

  end

  Order.state_machine.before_transition to: :confirm, do: :valid_installments?
  Order.state_machine.before_transition to: :confirm, do: :lock_payment_interest
end
