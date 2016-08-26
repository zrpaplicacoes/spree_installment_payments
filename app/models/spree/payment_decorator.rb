module Spree

  Payment.class_eval do
    
    def accept_installments?
      payment_method.has_installments?
    end

  end

end
