class AddCodeToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :code, :string
  end
end
