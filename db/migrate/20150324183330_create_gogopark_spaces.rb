class CreateGogoparkSpaces < ActiveRecord::Migration
  def change
    create_table :gogopark_spaces do |t|
      t.references :gogopark_address, index: true
      t.string :term
      t.string :type
      t.string :size
      t.string :description

      t.timestamps
    end
  end
end
