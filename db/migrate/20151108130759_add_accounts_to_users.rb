class AddAccountsToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :accounts, index: true
  end
end
