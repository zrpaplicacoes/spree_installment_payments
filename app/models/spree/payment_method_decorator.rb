module Spree

  PaymentMethod.class_eval do
    has_many :interests, dependent: :destroy

    validates :base_value, numericality: { greater_than_or_equal_to: 0 }, if: 'accept_installments?'

    def can_installment? order
      accept_installments? && max_installments(order) >= 1
    end

    def max_installments order
      installments = (order.total / base_value)
      installments.nan? ? 0 : ( installments.to_i >= max_number_of_installments ? max_number_of_installments : installments.to_i)
    end

    def format_options_for_select order
      options = []

      (1..max_installments(order)).each do |installment|
        options << [ installment_text(order, installment), installment ]
      end

      options
    end

    def installment_text order, installment
      interest = "#{interest_value_for(installment).round(4) * 100}%"
      total = total_with_interest_for(order, installment)
      per_month = (total / installment)

      total = Money.new(total, currency: order.currency).to_s
      per_month = Money.new(per_month, currency: order.currency).to_s

      Spree.t(payment_type_key(installment), total: total, per_month: per_month, interest: interest, installment: installment)
    end

    def payment_type_key installment
      index = 0
      index += interest_value_for(installment).zero? ? 0 : 2
      index += installment == 1 ? 0 : 1

      [
        :no_installment_without_interest, :installment_without_interest,
        :no_installment_with_interest, :installment_with_interest
      ][index]
    end

    def interest_value_for installment
      highest = 0
      values = interests.pluck(:number_of_installments, :value)

      pair = values.each { |pair| highest = pair[0] if installment >= pair[0] }.find { |pair| pair[0] == highest }

      pair.nil? ? 0 : pair[1]
    end

    def total_with_interest_for order, installment
      order.total * (( 1 + interest_value_for(installment) )**installment )
    end

  end

end
