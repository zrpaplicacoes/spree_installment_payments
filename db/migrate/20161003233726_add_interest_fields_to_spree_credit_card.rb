class AddInterestFieldsToSpreeCreditCard < ActiveRecord::Migration
  def change
    add_column :spree_credit_cards, :installments, :integer, default: 1
    add_column :spree_credit_cards, :interest, :decimal, precision: 10, scale: 4, default: 0.0
    add_column :spree_credit_cards, :charge_interest, :boolean, default: true, null: false
    add_column :spree_credit_cards, :interest_amount, :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
  end
end