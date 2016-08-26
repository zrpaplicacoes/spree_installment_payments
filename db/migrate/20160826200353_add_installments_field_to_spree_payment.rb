class AddInstallmentsFieldToSpreePayment < ActiveRecord::Migration
  def change
    add_column :spree_payments, :installments, :integer, default: 1
  end
end
