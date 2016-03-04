class AddTypeContactToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :typecontact, :string
  end
end
