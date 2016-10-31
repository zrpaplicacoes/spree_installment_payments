module Spree

  module OrderDecorator
    def save_payment_with_installments
      if valid_installments?
        payment.interest = payment.payment_method.interest_value_for(payment.installments)
        payment.charge_interest = payment.payment_method.charge_interest
        payment.interest_amount = (total_with_interest - total)
        payment.save
      else
        errors.add(:payments, Spree.t(:invalid_number_of_installments))
        payment.installments = 1
        payment.save
        false
      end
    end

    def payment
      return @payment if @payment.present?
      @payment = self.payments.last
    end

    def display_total_with_interest
      Spree::Money.new(total_with_interest, { currency: currency }).to_s
    end

    def display_total_per_installment
      Spree::Money.new(total_per_installment, { currency: currency }).to_s
    end

    private

    def total_per_installment
      (total / ( payment.installments >= 1 ? payment.installments : 1 )) * interest_adjustment
    end

    def total_with_interest
      total * interest_adjustment
    end

    def interest_adjustment
      (1 + payment.interest)**payment.installments
    end

  end


  Order.class_eval do
    prepend Spree::OrderDecorator

    def valid_installments?
      payment.installments >= 1 && payment.installments <= payment.payment_method.max_number_of_installments && payment.payment_method.accept_installments?
    end

  end

  Order.state_machine.before_transition to: :confirm, do: :save_payment_with_installments
end
