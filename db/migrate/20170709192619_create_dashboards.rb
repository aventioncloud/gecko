class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.integer :width
      t.integer :height
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
