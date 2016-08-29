$ ->
  ($ "#max_number_of_installments").change ->
    if @.value == "1"
      show_label()
    else
      hide_label()

  show_label = ->
    ($ "<div id='no_installment'>à vista</div>").insertAfter($ "#max_number_of_installments")

  hide_label = ->
    label = ($ "#max_number_of_installments").siblings "#no_installment"
    label.remove()
