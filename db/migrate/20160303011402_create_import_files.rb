class CreateImportFiles < ActiveRecord::Migration
  def change
    create_table :import_files do |t|
      t.string :docfile_file_name
      t.string :docfile_path
      t.string :docfile
      t.string :status
      t.string :message

      t.timestamps
    end
  end
end
