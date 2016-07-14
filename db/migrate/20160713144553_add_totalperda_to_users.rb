class AddTotalperdaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :totalperda, :integer
  end
end
