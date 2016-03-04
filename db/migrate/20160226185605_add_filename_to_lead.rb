class AddFilenameToLead < ActiveRecord::Migration
  def change
    add_column :leads, :docfile_file_name, :string
  end
end
