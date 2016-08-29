class AddNameToSpreeZoneInterest < ActiveRecord::Migration
  def change
    add_column :spree_zone_interests, :name, :string
  end
end
