class AddOwnerToAccountInvests < ActiveRecord::Migration
  def change
    add_reference :account_invests, :users, index: true
  end
end
