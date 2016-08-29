Deface::Override.new(
  :virtual_path  => "spree/admin/shared/sub_menu/_configuration",
  :insert_after  => "erb[loud]:contains('zones')",
  :text       => "<%= configurations_sidebar_menu_item(Spree.t(:zone_interests), spree.admin_zone_interests_path) if can? :manage, Spree::ZoneInterest %> ",
  :name          => "add_zone_interests_to_admin_configuration_sub_menu"
)
