Deface::Override.new(
  :virtual_path  => "spree/admin/payment_methods/index",
  :insert_before  => 'th.actions',
  :partial       => "spree/admin/payment_methods/installments_header",
  :name          => "add_installments_to_payment_methods_header"
)

Deface::Override.new(
  :virtual_path  => "spree/admin/payment_methods/index",
  :insert_before  => 'td.actions',
  :partial       => "spree/admin/payment_methods/installments_value",
  :name          => "add_installments_to_payment_methods_value"
)
