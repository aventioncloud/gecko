class CreatePlatformRoles < ActiveRecord::Migration
  def change
    create_table :platform_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
