Deface::Override.new(
  :virtual_path  => "spree/admin/zones/_form",
  :insert_before  => '[data-hook="type"]',
  :partial       => "spree/admin/zones/installments",
  :name          => "add_installments_to_zone"
)
