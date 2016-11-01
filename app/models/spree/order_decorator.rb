module Spree

  module OrderDecorator

    def save_interests
      raise Spree::Order::UnavailablePayment unless latest_processing_payment.present?
      latest_processing_payment.interest = current_payment_method.interest_value_for(installments)
      latest_processing_payment.save
    end

    def update_totals_after_payment
      Spree::OrderUpdater.new(self).update
    end

    def latest_processing_payment
      payments.processing.last ? payments.processing.last : Spree::Payment.none
    end

    def latest_completed_payment
      payments.completed.last ? payments.completed.last : Spree::Payment.none
    end

    def current_payment_method
      latest_processing_payment.payment_method
    end

    def installments_for_processing_payment
      latest_processing_payment.installments
    end

    def installments
      latest_completed_payment.installments || latest_processing_payment.installments
    end

    def display_total_per_installment
      Spree::Money.new(total_per_installment, { currency: currency }).to_s
    end

    def interest_adjustment
      latest_processing_payment ? latest_processing_payment.interest_adjustment : 1.0
    end

    def total_per_installment
      (latest_processing_payment.amount / ( latest_processing_payment.installments >= 1 ? latest_processing_payment.installments : 1 ))
    end

    def interest_amount
      (latest_processing_payment.amount - ( latest_processing_payment.amount * (1 - (latest_processing_payment.interest/(1 + latest_processing_payment.interest)))**latest_processing_payment.installments )).round(2)
    end

  end

  Order.class_eval do
    class UnavailablePayment < StandardError; end

    prepend Spree::OrderDecorator

    def valid_installments?
      current_payment_method && current_payment_method.accept_installments? && (latest_processing_payment.installments >= 1 && latest_processing_payment.installments <= current_payment_method.max_number_of_installments)
    end

  end

  Order.state_machine.after_transition from: :payment, do: :save_interests
  Order.state_machine.after_transition from: :payment, do: :update_totals_after_payment
end
