class AddInstallmentsFieldToSpreePayment < ActiveRecord::Migration
  def change
    add_column :spree_payments, :installments, :integer, default: 1
    add_column :spree_payments, :interest, :decimal, precision: 8, scale: 2, default: 0.0
    add_column :spree_payments, :charge_interest, :boolean, default: true, null: false
    add_column :spree_payments, :interest_amount, :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
  end
end
