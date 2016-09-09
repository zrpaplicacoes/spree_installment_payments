module Spree

  Payment.class_eval do
    after_create :update_source_with_charge_interest

    delegate *[:accept_installments?, :max_number_of_installments, :charge_interest ], to: :payment_method

    validate :valid_installments?

    private

    def valid_installments?
      interest = Spree::Interest.new(order: order, payment_method: payment_method)
      errors.add(:installments) unless accepted_installment_number?(interest)
    end

    def update_source_with_charge_interest
      source.update(charge_interest: payment_method.charge_interest)
    end

    def accepted_installment_number?(interest)
      interest.accept_installments? && 1 <= installments && installments <= interest.max_number_of_installments
    end

  end

end
