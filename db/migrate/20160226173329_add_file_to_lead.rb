class AddFileToLead < ActiveRecord::Migration
  def change
    add_column :leads, :docfile, :string
    add_column :leads, :docfile_path, :string
  end
end
