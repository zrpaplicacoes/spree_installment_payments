module Spree
  module OrderUpdaterDecorator

    def update
      update_totals
      if order.completed?
        update_payment_state
        update_shipments
        update_shipment_state
        update_shipment_total
        update_payment_total
      end
      run_hooks
      persist_totals
    end

    def order_original_total
      order.item_total + order.shipment_total + order.adjustment_total
    end

    def order_corrected_with_interest_total
      order_original_total * order.interest_adjustment
    end

    def update_order_total
      payments.each { |payment| payment.try(:set_amount, order_corrected_with_interest_total) }
      order.total = order_corrected_with_interest_total
    end

    def update_order_total_to_original
      payments.each { |payment| payment.try(:set_amount, order_original_total) }
      order.total = order_original_total
    end

  end

  OrderUpdater.class_eval do
    prepend Spree::OrderUpdaterDecorator
  end
end