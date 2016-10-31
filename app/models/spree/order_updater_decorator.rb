module Spree
  module OrderUpdaterDecorator

    def update_order_total
      super
      order.total = order.total * order.interest_adjustment if order.payments.completed.any?
    end

    def update_payment_total
      super
      order.payment_total = order.payment_total * order.interest_adjustment unless order.payments.completed.any?
    end

  end

  OrderUpdater.class_eval do
    prepend Spree::OrderUpdaterDecorator
  end
end
