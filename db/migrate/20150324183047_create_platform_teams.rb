class CreatePlatformTeams < ActiveRecord::Migration
  def change
    create_table :platform_teams do |t|
      t.references :platform_group, index: true
      t.references :users, index: true
      t.boolean :default

      t.timestamps
    end
  end
end
