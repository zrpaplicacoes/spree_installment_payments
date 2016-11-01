module Spree
  module OrderUpdaterDecorator

    def order_original_total
      order.item_total + order.shipment_total + order.adjustment_total
    end

    def order_corrected_with_interest_total
      order_original_total * order.interest_adjustment
    end

    def update_order_total
      order.total = order_corrected_with_interest_total
    end

    def update_order_total_to_original
      order.total = order_original_total
    end

  end

  OrderUpdater.class_eval do
    prepend Spree::OrderUpdaterDecorator
  end
end