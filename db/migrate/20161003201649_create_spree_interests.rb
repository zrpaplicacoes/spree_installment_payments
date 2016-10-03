class CreateSpreeInterests < ActiveRecord::Migration
  def change
    create_table :spree_interests do |t|
      t.integer :start_number_of_installments
      t.integer :end_number_of_installments
      t.decimal :value, precision: 8, scale: 2, default: 0.0
      t.timestamps null: false
    end
  end
end
