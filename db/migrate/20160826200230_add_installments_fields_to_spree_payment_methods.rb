class AddInstallmentsFieldsToSpreePaymentMethods < ActiveRecord::Migration
  def change
    add_column :spree_payment_methods, :accept_installments, :boolean, default: false
    add_column :spree_payment_methods, :max_number_of_installments, :integer, default: 1
    add_column :spree_payment_methods, :base_value, :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
  end
end
