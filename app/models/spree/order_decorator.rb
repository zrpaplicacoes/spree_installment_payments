module Spree
  Order.class_eval do

    def valid_installments?
      Spree::Interest.new(order: self)
      byebug
    end

    def installment_interests
      Spree::Interest.new(order: self).available_interests
    end

  end

  Order.state_machine.before_transition to: :confirm, do: :valid_installments?
end
