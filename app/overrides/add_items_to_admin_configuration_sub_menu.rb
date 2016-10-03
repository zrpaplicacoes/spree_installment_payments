Deface::Override.new(
  :virtual_path  => "spree/admin/shared/sub_menu/_configuration",
  :insert_after  => "erb[loud]:contains('zones')",
  :text       => "<%= configurations_sidebar_menu_item(Spree.t(:interests), spree.admin_interests_path) if can? :manage, Spree::Interest %> ",
  :name          => "add_items_to_admin_configuration_sub_menu"
)
