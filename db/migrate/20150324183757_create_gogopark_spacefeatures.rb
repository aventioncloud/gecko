class CreateGogoparkSpacefeatures < ActiveRecord::Migration
  def change
    create_table :gogopark_spacefeatures do |t|
      t.string :contactphone
      t.boolean :scheduleprivacy
      t.integer :maxheight
      t.boolean :eletricrecharge
      t.references :gogopark_space, index: true
      t.string :others

      t.timestamps
    end
  end
end
