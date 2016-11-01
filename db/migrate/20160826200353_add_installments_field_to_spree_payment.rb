class AddInstallmentsFieldToSpreePayment < ActiveRecord::Migration
  def change
    add_column :spree_payments, :installments, :integer, default: 1
    add_column :spree_payments, :interest, :decimal, precision: 10, scale: 4, default: 0.0
  end
end