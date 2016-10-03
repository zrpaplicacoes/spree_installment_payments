module Spree

  PaymentMethod.class_eval do
    has_many :interests, dependent: :destroy

    def can_installment? order
    max_installments(order) > 1 && accept_installments?
  end

    def max_installments order
      (order.total / base_value).to_i
    end

  end

end
