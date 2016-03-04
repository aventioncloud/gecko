class CreateLeadFiles < ActiveRecord::Migration
  def change
    create_table :lead_files do |t|
      t.string :docfile_file_name
      t.string :docfile_path
      t.string :docfile

      t.timestamps
    end
  end
end
