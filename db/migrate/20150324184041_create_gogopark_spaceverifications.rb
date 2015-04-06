class CreateGogoparkSpaceverifications < ActiveRecord::Migration
  def change
    create_table :gogopark_spaceverifications do |t|
      t.boolean :spaceverications
      t.boolean :spaceverified
      t.references :users, index: true
      t.string :description
      t.references :gogopark_address, index: true

      t.timestamps
    end
  end
end
