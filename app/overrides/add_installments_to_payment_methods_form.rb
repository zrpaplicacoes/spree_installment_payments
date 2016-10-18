Deface::Override.new(
  :virtual_path  => "spree/admin/payment_methods/_form",
  :insert_after  => '[data-hook="auto_capture"]',
  :partial       => "spree/admin/payment_methods/installments",
  :name          => "add_installments_to_zone_form"
)
