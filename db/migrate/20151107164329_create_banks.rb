class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name
      t.string :numberbank
      t.string :imagesmall
      t.string :imagelarge

      t.timestamps
    end
  end
end
