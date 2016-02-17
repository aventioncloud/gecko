class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :dadgroup
      t.references :users, index: true

      t.timestamps
    end
  end
end
