module Spree

  PaymentMethod.class_eval do
    has_many :interests, dependent: :destroy

    validates :base_value, numericality: { greater_than: 0 }, if: 'accept_installments?'

    def accept_installments_for? order
      accept_installments? && max_installments(order) >= 1
    end

    def format_options_for_select order
      options = []
      return options unless accept_installments?

      (1..max_installments(order)).each do |installments|
        options << [ installments_text(order, installments), installments ]
      end

      options
    end

    def interest_value_for installments
      highest = 0

      return highest unless accept_installments?

      values = interests.pluck(:number_of_installments, :value)
      pair = values.sort.each { |pair| highest = pair[0] if installments >= pair[0] }.find { |pair| pair[0] == highest }

      pair.nil? ? 0 : pair[1]
    end

    private

    def max_installments order
      return 1 unless accept_installments?
      installments = (order.total / base_value).to_i
      installments >= max_number_of_installments ? max_number_of_installments : installments
    end

    def installments_text order, installments
      interest = "#{interest_value_for(installments).round(4) * 100}%"
      total = total_with_interest_for(order, installments)
      per_month = (total / installments)

      total = Money.new(total, currency: order.currency).to_s
      per_month = Money.new(per_month, currency: order.currency).to_s

      Spree.t(payment_type_key(installments), total: total, per_month: per_month, interest: interest, installment: installments)
    end

    def total_with_interest_for order, installments
      interest = interest_value_for(installments)
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
