class CreateSpreeInterests < ActiveRecord::Migration
  def change
    create_table :spree_interests do |t|
      t.string :name
      t.integer :number_of_installments
      t.integer :payment_method_id, null: false
      t.decimal :value, precision: 10, scale: 4, default: 0.0
      t.timestamps null: false
    end
  end
end
