class AddActiveToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :active, :string
  end
end
