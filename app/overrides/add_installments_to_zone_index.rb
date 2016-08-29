Deface::Override.new(
  :virtual_path  => "spree/admin/zones/index",
  :insert_before  => 'th.actions',
  :partial       => "spree/admin/zones/installments_header",
  :name          => "add_installments_to_zone_index_header"
)

Deface::Override.new(
  :virtual_path  => "spree/admin/zones/index",
  :insert_before  => 'td.actions',
  :partial       => "spree/admin/zones/installments_value",
  :name          => "add_installments_to_zone_index_value"
)
