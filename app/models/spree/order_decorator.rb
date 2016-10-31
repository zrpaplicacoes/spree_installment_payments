module Spree

  module OrderDecorator
    def save_payment_with_installments
      if valid_installments?
        payment.interest = payment.payment_method.interest_value_for(payment.installments)
        payment.charge_interest = payment.payment_method.charge_interest
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

    def display_total_per_installment
      Spree::Money.new(total_per_installment, { currency: currency }).to_s
    end

    def interest_adjustment
      if !payment.nil? && !payment.payment_method.nil?
        (1 + payment.payment_method.interest_value_for(payment.installments))**payment.installments
      else
        1
      end
    end

    def total_per_installment
      (total / ( payment.installments >= 1 ? payment.installments : 1 ))
    end

    def interest_amount
      (total - ( total * (1 - (payment.interest/(1 + payment.interest)))**payment.installments )).round(2)
    end

  end

  Order.class_eval do
    prepend Spree::OrderDecorator

    def valid_installments?
      payment.payment_method.accept_installments? && (payment.installments >= 1 && payment.installments <= payment.payment_method.max_number_of_installments)
    end

  end

  Order.state_machine.before_transition to: :confirm, do: :save_payment_with_installments
end
