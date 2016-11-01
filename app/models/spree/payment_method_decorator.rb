module Spree

  PaymentMethod.class_eval do
    has_many :interests, dependent: :destroy

    validates :base_value, numericality: { greater_than: 0 }, if: 'accept_installments?'

    def can_installment? order
      accept_installments? && max_installments(order) >= 1
    end

    def format_options_for_select order
      options = []

      return options unless accept_installments?

      (1..max_installments(order)).each do |installment|
        options << [ installment_text(order, installment), installment ]
      end

      options
    end

    def interest_value_for installment
      highest = 0

      return highest unless accept_installments?

      values = interests.pluck(:number_of_installments, :value)
      pair = values.each { |pair| highest = pair[0] if installment >= pair[0] }.find { |pair| pair[0] == highest }

      pair.nil? ? 0 : pair[1]
    end

    private

    def max_installments order
      return 1 unless accept_installments?

      installments = (order.total / base_value).to_i
      installments >= max_number_of_installments ? max_number_of_installments : installments
    end

    def installment_text order, installment
      interest = "#{interest_value_for(installment).round(4) * 100}%"
      total = total_with_interest_for(order, installment)
      per_month = (total / installment)

      total = Money.new(total, currency: order.currency).to_s
      per_month = Money.new(per_month, currency: order.currency).to_s

      Spree.t(payment_type_key(installment), total: total, per_month: per_month, interest: interest, installment: installment)
    end

    def total_with_interest_for order, installments
      interest = interest_value_for(installment)
      interest.zero? ? order.total : order.total * ( ( 1 + interest )**installments )
    end

    def payment_type_key installments
      index = 0
      index += interest_value_for(installments).zero? ? 0 : 2
      index += installments == 1 ? 0 : 1

      [
        :no_installment_without_interest, :installment_without_interest,
        :no_installment_with_interest, :installment_with_interest
      ][index]
    end

  end

end
