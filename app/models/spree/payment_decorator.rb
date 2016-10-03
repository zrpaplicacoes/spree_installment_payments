module Spree

  Payment.class_eval do
    with_options dependent: :delete_all do
      has_many :adjustments, as: :adjustable
    end

    after_create :update_source_with_charge_interest

    delegate *[:accept_installments?, :max_number_of_installments, :charge_interest ], to: :payment_method

    private

    def update_source_with_charge_interest
      payment_source.update(charge_interest: payment_method.charge_interest)
    end

    def remove_payment_source_installments
      payment_source.update(installments: 1)
    end

    def accepted_installment_number?(interest)
      interest.available_installments? && 1 <= installments && installments <= interest.max_number_of_installments
    end

    def add_error_and_invalidate_payment attribute, message
      errors.add(attribute, message)
      self.state = :failed
      false
    end

  end

end
