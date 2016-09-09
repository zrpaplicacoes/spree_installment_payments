Deface::Override.new(
  virtual_path: "spree/checkout/payment/_gateway",
  insert_after: ".row",
  partial: "spree/checkout/payment/installments",
  name: "add_installments_to_checkout_payment"
)
