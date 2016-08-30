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

    def format_options_for_select
      interests = @zone.interests.order(:start_number_of_installments)
      range_start = interests.first.start_number_of_installments
      range_end = interests.last.end_number_of_installments

      range_start_fix = 1 >= (range_start - 1) ? 1 : range_start - 1
      missing_start_range = (1..range_start_fix)

      range_end_fix = max_number_of_installments <= (range_end + 1) ? max_number_of_installments : range_end + 1
      missing_end_range = (range_end_fix..max_number_of_installments)

      ranges = [ { range: missing_start_range, interest: 0 } ]
      interests.each do |interest|
        normalized_end_range = interest.end_number_of_installments > max_number_of_installments ? max_number_of_installments : interest.end_number_of_installments
        ranges << { range: (interest.start_number_of_installments..normalized_end_range), interest: interest.interest.to_f }
      end

      ranges << { range: missing_end_range, interest: interests.last.interest.to_f }

      ranges = ranges.reject { |interest| interest[:range].size == 1 }

      normalized_ranges = []
      ranges = ranges.each do |interest|
        normalized_ranges = interest[:range].map do |installments|
          installments_text(interest[:interest], installments)
          [installments_text(interest[:interest], installments), installments]
        end
      end

      normalized_ranges

    end

    def installments_text interest, installments
      total = @order.item_total.to_f.round(4)
      per_item = (total / installments).to_f.round(4)
      interest_percentage = "#{(interest * 100).round(4)}%"

      if interest == 0
        if installments == 1
          Spree.t(:no_installments_without_interest, total: total.to_money.format)
        else
          Spree.t(:installments_without_interest, total: total.to_money.format, per_item: per_item.to_money.format, installments: installments)
        end
      else
        if installments == 1
          Spree.t(:no_installments_with_interest, total: (total * (1 + interest)).to_money.format, interest: interest_percentage)
        else
          Spree.t(:installments_with_interest, total: (total * (1 + interest)).to_money.format, per_item: (per_item * (1 + interest)).to_money.format, interest: interest_percentage, installments: installments)
        end
      end
    end

    def retrieve
      applicable? ? interest : 0.0
    end

    def max_number_of_installments
      [
        max_number_of_installments_for_order,
        max_number_of_installments_for_zone,
        max_number_of_installments_for_payment_methods
      ].min
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
