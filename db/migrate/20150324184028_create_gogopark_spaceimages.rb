class CreateGogoparkSpaceimages < ActiveRecord::Migration
  def change
    create_table :gogopark_spaceimages do |t|
      t.string :filename
      t.string :description
      t.references :gogopark_space, index: true

      t.timestamps
    end
  end
end
