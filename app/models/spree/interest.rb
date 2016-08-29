module Spree
  class Interest

    class UndefinedOrder < StandardError; end
    class UndefinedZone < StandardError; end

    def initialize args
      raise UndefinedOrder unless args[:order].present?
      @order = args[:order]
      @zone = zone

      raise UndefinedZone unless @zone.present?
    end

    def retrieve
      applicable? ? interest : 0.0
    end

    def installment_error_message
      Spree.t('activerecord.errors.invalid_number_of_installments', number_of_installments: installments_for_order, max_allowed: max_number_of_installments ) unless allowed_number_of_installments?
    end

    def order_error_message
      Spree.t('activerecord.errors.non_installment_order') unless applicable?
    end

    private

    def applicable?
      @order.payments.all? { |payment| splitable?(payment) } &&
      number_of_installments.present? &&
      has_charge_interest?
    end

    def has_charge_interest?
      @order.payments.any? { |payment| payment.charge_interest? }
    end

    def splitable?(payment)
      payment.accept_installments? &&
      payment.max_number_of_installments > 1 &&
      payment.installments > 1
    end

    def allowed_number_of_installments?
      installments_for_order > 1 && installments_for_order <= max_number_of_installments
    end

    def number_of_installments
      installments_for_order if allowed_number_of_installments?
    end

    def installments_for_order
      @order.payments.map(&:installments).max
    end

    def max_number_of_installments
      [
        max_number_of_installments_for_order,
        max_number_of_installments_for_zone,
        max_number_of_installments_for_payment_methods
      ].min
    end

    def max_number_of_installments_for_order
      (@order.item_total.to_f / @zone.base_value.to_f).to_i
    end

    def max_number_of_installments_for_zone
      @zone.max_number_of_installments.to_i
    end

    def max_number_of_installments_for_payment_methods
      @order.payments.map(&:max_number_of_installments).min.to_i
    end

    def interest
      interest_for_installments = @zone.find_interest_for(number_of_installments)
      interest_for_installments.present ? interest_for_installments.interest.to_f : 0.0
    end

    def zone
      order_zones = @order.billing_address.country.zones | @order.billing_address.state.zones if @order.billing_address

      order_zones.present? ? order_zones.first : []
    end

  end
end
