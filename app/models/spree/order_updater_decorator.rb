module Spree
  module OrderUpdaterDecorator

    def update_order_total
      order.total = ( order.item_total + order.shipment_total + order.adjustment_total ) * order.interest_adjustment
    end

  end

  OrderUpdater.class_eval do
    prepend Spree::OrderUpdaterDecorator
  end
end
