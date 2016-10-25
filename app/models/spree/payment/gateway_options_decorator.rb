module Spree

  module Payment::GatewayOptionsDecorator
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
        :chargeInterest,
        :charge_interest
      ]
    end

    def chargeInterest
      @payment.has_charge_interest?
    end

    def charge_interest
      @payment.has_charge_interest?
    end

    def installments
      @payment.saved_installments
    end

    def subtotal
      order.item_total * @payment.interest_adjustment * 100
    end

  end

  Payment::GatewayOptions.class_eval do
    prepend Spree::Payment::GatewayOptionsDecorator
  end

end