class AddPlayeridToUser < ActiveRecord::Migration
  def change
    add_column :users, :playerid, :string
  end
end
