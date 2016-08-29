class AddBaseValueForInstallmentToSpreeZone < ActiveRecord::Migration
  def change
    add_column :spree_zones, :base_value, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
