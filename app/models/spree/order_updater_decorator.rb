module Spree
  module OrderUpdaterDecorator

    def update_order_total
      current_total = (order.item_total + order.shipment_total + order.adjustment_total)
      order.total = order.payments.present? && order.payments.last.state == "completed" ?  current_total * order.interest_adjustment : current_total
    end

  end

  OrderUpdater.class_eval do
    prepend Spree::OrderUpdaterDecorator
  end
end
