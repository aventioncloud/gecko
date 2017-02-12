class AddXmlPartToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :xmlpart, :text
  end
end
