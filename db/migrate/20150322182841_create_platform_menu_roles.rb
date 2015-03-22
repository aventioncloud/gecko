class CreatePlatformMenuRoles < ActiveRecord::Migration
  def change
    create_table :platform_menu_roles do |t|
      t.integer :menu_id
      t.integer :role_id
      t.string :principalid

      t.timestamps
    end
  end
end
