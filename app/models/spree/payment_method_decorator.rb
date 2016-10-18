module Spree

  PaymentMethod.class_eval do
    has_many :interests, dependent: :destroy

    validates :base_value, numericality: { greater_than_or_equal_to: 0 }, if: 'accept_installments?'

    def can_installment? order
      accept_installments? && max_installments(order) > 1
    end

    def max_installments order
      installments = (order.total / base_value)
      installments.nan? ? 0 : installments.to_i
    end

  end

end
