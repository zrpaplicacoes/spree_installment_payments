module Spree
  class Interest

    class UndefinedOrder < StandardError; end
    class UndefinedZone < StandardError; end
    class UndefinedPaymentMethod < StandardError; end

    def initialize args
      raise UndefinedOrder unless args[:order].present?
      raise UndefinedPaymentMethod unless args[:payment_method].present?
      @order = args[:order]
      @payment_method = args[:payment_method]
      @zone = zone

      raise UndefinedZone unless @zone.present?
    end

    def format_options_for_select
      range_select_options = []

      interests_for_installments.each do |interest_for_installments|
        interest = interest_for_installments[:interest]
        convert_to_option = Proc.new { |installment| [installments_text(interest.to_f, installment), installment] }

        result = Array(interest_for_installments[:range]).map(&convert_to_option)
        range_select_options = range_select_options | result

      end
      range_select_options
    end

    def retrieve
      applicable? ? interest : 0.0
    end

    def display_installments?
      @payment_method.accept_installments? && max_number_of_installments > 1
    end

    def max_number_of_installments
      [
        max_number_of_installments_for_order,
        max_number_of_installments_for_zone,
        @payment_method.max_number_of_installments
      ].min
    end

    def installment_error_message
      Spree.t('activerecord.errors.invalid_number_of_installments', number_of_installments: installments_for_order, max_allowed: max_number_of_installments ) unless allowed_number_of_installments?
    end

    def order_error_message
      Spree.t('activerecord.errors.non_installment_order') unless applicable?
    end

    private

    def interests_for_installments
      interests = @zone.interests.where(payment_method: @payment_method).order(:start_number_of_installments)
      interests = interests.map { |interest| interest.to_hash_range }

      return [ { range: 1..max_number_of_installments, interest: 0 } ] if interests.empty?

      missing = []
      min_installments_range = interests.first[:range]
      max_installments_range = interests.last[:range]

      missing.push( { range: [1, min_installments_range.first - 1], interest: 0 } ) if ( (min_installments_range.first - 1) >= 1)
      missing.push( { range: [max_installments_range.last + 1, max_number_of_installments], interest: interests.last[:interest] } ) if ( (max_installments_range.last + 1) <= max_number_of_installments )
      ranges = interests | missing

      ranges.uniq.sort_by { |interest| interest[:range].first }.map do |interest|
        interest[:single] = (interest[:range].first == interest[:range].last)
        interest[:range] = interest[:single] ? interest[:range].first : (interest[:range].first)..(interest[:range].last)
        interest
      end
    end

    def installments_text interest, installments
      total = @order.display_total.money
      total_with_interest = total * (1 + interest)
      per_item = (total / installments)
      per_item_with_interest = (total_with_interest / installments)
      interest_percentage = "#{(interest * 100).round(4)}%"

      text_to_use = [interest == 0 && installments == 1, interest == 0 && installments > 1, interest > 0 && installments == 1, interest > 0 && installments > 1].find_index(true)

      [
        Spree.t(:no_installments_without_interest, total: total.format),
        Spree.t(:installments_without_interest, total: total.format, per_item: per_item.format, installments: installments), Spree.t(:no_installments_with_interest, total: total_with_interest.format, interest: interest_percentage), Spree.t(:installments_with_interest, total: total_with_interest.format, per_item: per_item_with_interest.format, interest: interest_percentage, installments: installments)
      ][text_to_use]

    end

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

    def max_number_of_installments_for_order
      (@order.item_total.to_f / @zone.base_value.to_f).to_i
    end

    def max_number_of_installments_for_zone
      @zone.max_number_of_installments.to_i
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
