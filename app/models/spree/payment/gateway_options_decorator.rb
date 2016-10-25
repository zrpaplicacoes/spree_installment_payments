module Spree

  module GatewayOptionsDecorator
    def hash_methods
      [
        :email,
        :customer,
        :customer_id,
        :ip,
        :order_id,
        :shipping,
        :tax,
        :subtotal,
        :discount,
        :currency,
        :billing_address,
        :shipping_address,
        :installments,
        :charge_interest
      ]
    end

    def charge_interest
      @payment.payment_method.charge_interest
    end

    def installments
      @payment.installments || 1
    end

    private

    def interest_adjusment
      if @payment.interest.present? && !@payment.interest.zero?
        if payment.installments.present? && payment.installments > 1
          (1.0 + @payment.interest)**payment.installments
        else
          (1.0 + @payment.interest)
        end
      else
        1.0
      end
    end

    def exchange_multiplier
      (@payment.payment_method.try(:exchange_multiplier) || 1.0) * interest_adjusment
    end

  end


  GatewayOptions.class_eval do
    prepend Spree::GatewayOptionsDecorator
  end

end