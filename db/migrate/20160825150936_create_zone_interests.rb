class CreateZoneInterests < ActiveRecord::Migration
  def change
    create_table :zone_interests do |t|
      t.integer :start_number_of_installments
      t.integer :end_number_of_installments
      t.numericspree_zone_id :interest

      t.timestamps null: false
    end
  end
end
