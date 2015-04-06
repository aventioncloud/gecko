class AddActiveToGogoparkAddress < ActiveRecord::Migration
  def change
    add_column :gogopark_addresses, :active, :boolean
  end
end
