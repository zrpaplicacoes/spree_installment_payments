class AddNumberOfInstallmentsToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :number_of_installments, :integer, default: 1
  end
end
