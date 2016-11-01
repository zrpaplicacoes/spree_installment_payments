module Spree
  module CheckoutControllerDecorator

    def ensure_valid_state
      if @order.state != correct_state && !skip_state_validation?
        flash.keep
        @order.update_column(:state, correct_state)
        Spree::OrderUpdater.new(@order).update_order_total_to_original
        redirect_to checkout_state_path(@order.state)
      end
    end

    private

    def reset_order_total
      Spree::OrderUpdater.new(@order).update_order_total_to_original if params[:state] == 'payment'
    end

    def insufficient_payment?
      params[:state] == "confirm" &&
      @order.payment_required? &&
      current_payment_total != @order.total
    end

    def current_payment_total
      @order.payments.valid.inject(0) { |sum, payment| sum += payment.amount }.round(2)
    end

  end

  CheckoutController.class_eval do
    prepend Spree::CheckoutControllerDecorator
    before_action :reset_order_total
  end

end