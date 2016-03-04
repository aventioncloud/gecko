class AddFileToLeadHistory < ActiveRecord::Migration
  def change
    add_column :lead_histories, :lead_file_id, :integer
  end
end
