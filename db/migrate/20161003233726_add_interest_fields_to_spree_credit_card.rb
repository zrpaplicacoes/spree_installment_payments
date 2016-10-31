class AddInterestFieldsToSpreeCreditCard < ActiveRecord::Migration
  def change
    add_column :spree_credit_cards, :installments, :integer, default: 1
    add_column :spree_credit_cards, :interest, :decimal, precision: 10, scale: 4, default: 0.0
  end
end