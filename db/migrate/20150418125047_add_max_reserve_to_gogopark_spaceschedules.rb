class AddMaxReserveToGogoparkSpaceschedules < ActiveRecord::Migration
  def change
    add_column :gogopark_spaceschedules, :maxreserve, :integer
    add_column :gogopark_spaceschedules, :description, :string
    add_column :gogopark_spaceschedules, :active, :boolean
    add_column :gogopark_spaceschedules, :name, :string
  end
end
