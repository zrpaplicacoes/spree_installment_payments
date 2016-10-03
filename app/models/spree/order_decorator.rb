module Spree
  Order.class_eval do

    def set_installments
      self.has_installments = payment.valid_installments? && payment.installments > 1
      payment.interest = interest.retrieve.round(4) if !interest.retrieve.nil? && interest.retrieve > 0
      payment.amount = total_with_interest
    end

    def save_installments
      begin
        ActiveRecord::Base.transaction do
          self.save! && payment.save!
        end
        true
      rescue StandardError
        errors.add(:payments, I18n.t('activerecord.errors.invalid_payment'))
        false
      end
    end

    def payment
      return @payment if @payment.present?
      @payment = self.payments.last
    end

    def display_total
      Spree::Money.new(total_with_interest, { currency: currency }).to_s
    end

    def display_total_per_installment
      Spree::Money.new(total_per_installment, { currency: currency }).to_s
    end

    private

    def total_per_installment
      factor = has_installments? ? (1.0 / payment.installments) : 1.0
      total_with_interest * factor
    end

    def total_with_interest
      total * interest_adjustment
    end

    def interest_adjustment
      #
      # (1 + payment.interest)**payment.installments
      1
    end

  end

  Order.state_machine.before_transition to: :confirm, do: :set_installments
  Order.state_machine.before_transition to: :confirm, do: :save_installments
end
