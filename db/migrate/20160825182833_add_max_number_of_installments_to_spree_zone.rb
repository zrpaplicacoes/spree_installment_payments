class AddMaxNumberOfInstallmentsToSpreeZone < ActiveRecord::Migration
  def change
    add_column :spree_zones, :max_number_of_installments, :integer, default: 1
  end
end
