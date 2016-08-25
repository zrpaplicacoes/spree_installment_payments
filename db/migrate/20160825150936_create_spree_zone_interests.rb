class CreateSpreeZoneInterests < ActiveRecord::Migration
  def change
    create_table :spree_zone_interests do |t|
      t.integer :spree_zone_id
      t.integer :start_number_of_installments
      t.integer :end_number_of_installments
      t.float :interest, precision: 4

      t.timestamps null: false
    end
  end
end
