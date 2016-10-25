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
        :charge_interest
      ]
    end

    def charge_interest
      @payment.payment_method.accept_installments? ? @payment.payment_method.charge_interest : false
    end

    def installments
      @payment.payment_method.accept_installments ? (@payment.installments || 1) : 1
    end

    def subtotal
      order.item_total * interest_adjustment * 100
    end

    def interest_adjustment
      begin
        if @payment.state == "processing"
          interest = @payment.payment_method.interest_value_for(installments)
          @payment.update(interest: interest)
          @payment.reload
        end

        if charge_interest && @payment.interest.present? && !@payment.interest.zero?
          if @payment.installments.present? && @payment.installments > 1
            (1.0 + @payment.interest)**@payment.installments
          else
            (1.0 + @payment.interest)
          end
        else
          1.0
        end
      rescue NoMethodError
        1.0
      end
    end

  end

  Payment::GatewayOptions.class_eval do
    prepend Spree::Payment::GatewayOptionsDecorator
  end

end