class CreateGogoparkProgresses < ActiveRecord::Migration
  def change
    create_table :gogopark_progresses do |t|
      t.references :users, index: true
      t.datetime :checkin
      t.datetime :checkout
      t.references :gogopark_spaceschedule, index: true
      t.float :price

      t.timestamps
    end
  end
end
