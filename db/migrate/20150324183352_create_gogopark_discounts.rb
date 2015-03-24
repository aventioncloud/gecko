class CreateGogoparkDiscounts < ActiveRecord::Migration
  def change
    create_table :gogopark_discounts do |t|
      t.references :platform_group, index: true
      t.references :users, index: true
      t.float :price
      t.string :typediscount

      t.timestamps
    end
  end
end
