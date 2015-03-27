class AddFieldnameToGogoparkAddresses < ActiveRecord::Migration
  def change
    add_column :gogopark_addresses, :amount, :integer
  end
end
