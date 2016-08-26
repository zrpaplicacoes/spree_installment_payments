module Spree
  Order.class_eval do

    def charge_interest?

    end

    def max_number_of_installments

    end

    def valid_installments?
      byebug
    end

  end

  Order.state_machine.before_transition to: :confirm, do: :valid_installments?
end
