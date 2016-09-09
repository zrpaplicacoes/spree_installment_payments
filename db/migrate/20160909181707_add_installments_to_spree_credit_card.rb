class AddInstallmentsToSpreeCreditCard < ActiveRecord::Migration
  def change
    add_column :spree_credit_cards, :installments, :integer, default: 1, null: false
    add_column :spree_credit_cards, :charge_interest, :boolean, default: false, null: false
  end
end
