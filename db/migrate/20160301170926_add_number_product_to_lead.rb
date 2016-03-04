class AddNumberProductToLead < ActiveRecord::Migration
  def change
    add_column :leads, :numberproduct, :integer
  end
end
