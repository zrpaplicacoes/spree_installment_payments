module Spree
  Order.class_eval do

    def valid_installments?
      byebug
      Spree::Interest.new(order: self)
    end

  end

  Order.state_machine.before_transition to: :confirm, do: :valid_installments?
end
