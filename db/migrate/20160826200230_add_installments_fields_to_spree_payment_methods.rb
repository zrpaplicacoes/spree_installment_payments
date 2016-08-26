class AddInstallmentsFieldsToSpreePaymentMethods < ActiveRecord::Migration
  def change
    add_column :spree_payment_methods, :accept_installments, :boolean, default: false
    add_column :spree_payment_methods, :max_number_of_installments, :integer, default: 1
    add_column :spree_payment_methods, :charge_interest, :boolean, default: false
  end
end
