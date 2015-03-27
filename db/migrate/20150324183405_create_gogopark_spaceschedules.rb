class CreateGogoparkSpaceschedules < ActiveRecord::Migration
  def change
    create_table :gogopark_spaceschedules do |t|
      t.datetime :dateref
      t.integer :dayofweek
      t.time :end
      t.time :start
      t.float :price
      t.references :gogopark_address, index: true
      t.references :gogopark_discounts, index: true

      t.timestamps
    end
  end
end
