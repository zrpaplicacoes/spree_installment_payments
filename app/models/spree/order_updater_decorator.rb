module Spree
  module OrderUpdaterDecorator

    def update_payment_total
      super
      order.payment_total = order.payment_total * order.interest_adjustment
    end

  end

  OrderUpdater.class_eval do
    prepend Spree::OrderUpdaterDecorator
  end
end
