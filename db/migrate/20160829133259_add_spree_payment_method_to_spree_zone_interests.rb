class AddSpreePaymentMethodToSpreeZoneInterests < ActiveRecord::Migration
  def change
    add_column :spree_zone_interests, :payment_method_id, :integer
  end
end
