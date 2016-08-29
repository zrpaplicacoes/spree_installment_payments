$ ->
  ($ document).ready ->
    show_label() if no_installment()

  ($ "#max_number_of_installments").change ->
    if no_installment()
      show_label()
    else
      hide_label()

  no_installment = ->
    $("#max_number_of_installments").val() == "1"

  show_label = ->
    ($ "<label id='no_installment'>à vista</label>").insertAfter($ "#max_number_of_installments")

  hide_label = ->
    label = ($ "#max_number_of_installments").siblings "#no_installment"
    label.remove()
