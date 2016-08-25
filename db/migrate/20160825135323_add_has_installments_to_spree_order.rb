class AddHasInstallmentsToSpreeOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :has_installments, :boolean, default: false
  end
end
