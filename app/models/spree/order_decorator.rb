module Spree
  Order.class_eval do

  end

  # Order.state_machine.before_transition to: :confirm, do: :valid_installments?
end
