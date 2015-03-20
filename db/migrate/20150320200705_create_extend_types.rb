class CreateExtendTypes < ActiveRecord::Migration
  def change
    create_table :extend_types do |t|
      t.string :key
      t.string :controller
      t.string :link
      t.string :type
      t.string :templateOptions
      t.string :expressionProperties
      t.string :templateurl
      t.string :template
      t.string :data
      t.string :validation
      t.string :watcher
      t.string :runExpressions

      t.timestamps
    end
  end
end
