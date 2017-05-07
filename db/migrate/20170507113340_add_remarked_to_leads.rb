class AddRemarkedToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :remarked, :integer
  end
end
