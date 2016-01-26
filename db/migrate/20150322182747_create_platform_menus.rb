class CreatePlatformMenus < ActiveRecord::Migration
  def change
    create_table :platform_menus do |t|
      t.string :name
      t.string :url
      t.string :href
      t.integer :short
      t.integer :menudad
      t.string :icon

      t.timestamps
    end
  end
end
