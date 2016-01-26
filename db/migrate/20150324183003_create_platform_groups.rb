class CreatePlatformGroups < ActiveRecord::Migration
  def change
    create_table :platform_groups do |t|
      t.string :name
      t.integer :groupdad
      t.references :users, index: true

      t.timestamps
    end
  end
end
