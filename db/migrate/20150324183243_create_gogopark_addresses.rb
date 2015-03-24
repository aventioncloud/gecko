class CreateGogoparkAddresses < ActiveRecord::Migration
  def change
    create_table :gogopark_addresses do |t|
      t.references :users, index: true
      t.references :platform_group, index: true
      t.string :address
      t.integer :numberhome
      t.string :complement
      t.string :neighborhood
      t.string :postcode
      t.references :cidade, index: true
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
