class AddBaseValueForInstallmentToSpreeZone < ActiveRecord::Migration
  def change
    add_column :spree_zones, :base_value, :float, default: 100.0
  end
end
