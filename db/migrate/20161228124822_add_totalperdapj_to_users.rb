class AddTotalperdapjToUsers < ActiveRecord::Migration
  def change
    add_column :users, :totalperdapj, :integer
  end
end
