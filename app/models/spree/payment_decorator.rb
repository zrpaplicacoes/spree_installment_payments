module Spree

  Payment.class_eval do

    delegated_methods = [
      :accept_installments?,
      :max_number_of_installments,
      :charge_interest
    ]

    delegate *delegated_methods, to: :payment_method

  end

end
