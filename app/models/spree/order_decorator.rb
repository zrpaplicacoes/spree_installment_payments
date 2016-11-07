module Spree

  module OrderDecorator

    def set_order_totals
      byebug
      raise Spree::Order::UnavailablePayment unless latest_checkout_payment.present? || latest_completed_payment.present?

      payments.each { |payment| payment.update(interest: current_payment_method.interest_value_for(installments)) unless payment.completed? }
      Spree::OrderUpdater.new(self.reload).update
      true
    end

    def reset_order_totals
      payments.each { |payment| payment.update(interest: 0.0) }
      Spree::OrderUpdater.new(self.reload).update_order_total_to_original
      true
    end

    def formatted_interest
      "#{(latest_payment.interest * 100).round(4)}% a.m"
    end

    def latest_checkout_payment
      payments.checkout.last
    end

    def latest_completed_payment
      payments.completed.last
    end

    def latest_payment
      latest_completed_payment || latest_checkout_payment || nil
    end

    def current_payment_method
      latest_checkout_payment.nil? ? latest_completed_payment.payment_method : latest_checkout_payment.payment_method
    end

    def installments_for_processing_payment
      latest_checkout_payment.installments
    end

    def installments
      payments.last.installments
    end

    def installments_text
      latest_completed_payment.try(:installments) || latest_checkout_payment.try(:installments) || Spree.t(:no_installments) || latest_valid_payment.try(:installments)
    end

    def has_installments?
      installments.to_i > 1
    end

    def display_total_per_installment
      Spree::Money.new(total_per_installment, { currency: currency }).to_s
    end

    def interest_adjustment
      latest_payment ? latest_payment.interest_adjustment : 1.0
    end

    def total_per_installment
      ((latest_payment.try(:amount) || 0) / ( latest_payment.try(:installments) ? latest_payment.installments : 1 ))
    end

    def interest_amount
      (latest_payment.amount - latest_payment.amount).round(2)
    end

  end

  Order.class_eval do
    prepend Spree::OrderDecorator

    def valid_installments?
      current_payment_method && current_payment_method.accept_installments? && (latest_checkout_payment.installments >= 1 && latest_checkout_payment.installments <= current_payment_method.max_number_of_installments)
    end

  end

  Order.state_machine.before_transition to: :payment, do: :reset_order_totals
  Order.state_machine.after_transition from: :payment, do: :set_order_totals
end
