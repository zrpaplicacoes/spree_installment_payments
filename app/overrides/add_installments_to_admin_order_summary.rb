Deface::Override.new(
  virtual_path: "spree/admin/orders/index",
  insert_top: "[data-hook='admin_orders_index_headers']",
  partial: "spree/admin/orders/installments_header",
  name: "add_installments_to_admin_order_summary_index_headers"
)

Deface::Override.new(
  virtual_path: "spree/admin/orders/index",
  insert_top: "[data-hook='admin_orders_index_rows']",
  partial: "spree/admin/orders/installments_value",
  name: "add_installments_to_admin_order_summary_index_values"
)

Deface::Override.new(
  virtual_path: "spree/admin/shared/_order_summary",
  insert_bottom: ".additional-info",
  partial: "spree/admin/shared/installments_summary",
  name: "add_installments_to_admin_order_summary_edit"
)
