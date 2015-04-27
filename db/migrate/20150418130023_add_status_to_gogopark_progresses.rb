class AddStatusToGogoparkProgresses < ActiveRecord::Migration
  def change
    add_column :gogopark_progresses, :status, :string
  end
end
