class AddGroupToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :groups, index: true
    add_column :users, :isemail, :string
    add_column :users, :islead, :string
    add_column :users, :celular, :string
  end
end
