Deface::Override.new(
  virtual_path: "spree/shared/_order_details",
  insert_after: "#order-total .warning.total",
  partial: "spree/checkout/summary/installments",
  name: "add_installments_to_order_details"
)
