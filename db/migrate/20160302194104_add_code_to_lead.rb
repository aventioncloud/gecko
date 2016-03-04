class AddCodeToLead < ActiveRecord::Migration
  def change
    add_column :leads, :code, :string
  end
end
