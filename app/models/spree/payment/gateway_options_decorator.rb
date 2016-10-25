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
      if @payment.saved_installments == 1
        nil
      else
        @payment.has_charge_interest? ? "Y" : "N"
      end
    end

    def charge_interest
      chargeInterest
    end

    def installments
      @payment.saved_installments == 1 ? nil : @payment.saved_installments
    end

    def subtotal
      order.item_total * @payment.interest_adjustment * 100
    end

  end

  Payment::GatewayOptions.class_eval do
    prepend Spree::Payment::GatewayOptionsDecorator
  end

end