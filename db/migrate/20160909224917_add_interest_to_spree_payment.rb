class AddInterestToSpreePayment < ActiveRecord::Migration
  def change
    add_column :spree_payments, :interest, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
