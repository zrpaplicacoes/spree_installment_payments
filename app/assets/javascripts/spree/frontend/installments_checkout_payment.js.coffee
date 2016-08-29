class Installment
  calculated_interest = (installment) ->
    window.order_total * interest_for(installment)

  interest_for = (installment) ->
    $(window.installment_interests).find((interest) ->
      
    )

$ ->
  ($ "#payment-methods .js-installments").on("change focusout", () =>
    value = this.value
    policy = window.installments
  )
