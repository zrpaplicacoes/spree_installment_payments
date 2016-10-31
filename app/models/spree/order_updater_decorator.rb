module Spree
  module OrderUpdaterDecorator

    def update_order_total
      order.total = ( order.item_total + order.shipment_total + order.adjustment_total )
      order.total = order.total * order.interest_adjustment if !order.payment.nil? && order.payment.state != "failed" && order.payment.state != "processing"
    end

  end

  OrderUpdater.class_eval do
    prepend Spree::OrderUpdaterDecorator
  end
end
