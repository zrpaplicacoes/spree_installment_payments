Deface::Override.new(
  :virtual_path  => "spree/admin/zones/form",
  :insert_after  => '.panel-body',
  :partial       => "spree/admin/zones/installments",
  :name          => "add_installments_to_zone"
)
