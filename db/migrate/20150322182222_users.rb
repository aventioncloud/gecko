class Users < ActiveRecord::Migration
  def change
    add_column :users, :roles, :integer
  end
end
