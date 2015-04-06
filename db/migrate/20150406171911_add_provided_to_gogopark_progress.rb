class AddProvidedToGogoparkProgress < ActiveRecord::Migration
  def change
    add_column :gogopark_progresses, :provided_start, :datetime
    add_column :gogopark_progresses, :provided_end, :datetime
  end
end
