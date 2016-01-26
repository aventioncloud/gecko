class CreateExtendSettings < ActiveRecord::Migration
  def change
    create_table :extend_settings do |t|
      t.integer :application_id
      t.string :module
      t.integer :extend_type_id
      t.string :class
      t.string :field
      t.string :label
      t.string :description
      t.string :defaultvalue
      t.string :options
      t.integer :sortorder

      t.timestamps
    end
  end
end
