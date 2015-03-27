class CreateGogoparkSpaces < ActiveRecord::Migration
  def change
    create_table :gogopark_spaces do |t|
      t.string :term
      t.string :type
      t.string :description
      
      t.references :platform_group, index: true
      t.references :users, index: true

      t.timestamps
    end
  end
end
