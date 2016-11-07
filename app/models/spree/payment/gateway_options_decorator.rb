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
        :installments
      ]
    end

    def installments
      order.installments
    end

  end

  Payment::GatewayOptions.class_eval do
    prepend Spree::Payment::GatewayOptionsDecorator
  end

end
