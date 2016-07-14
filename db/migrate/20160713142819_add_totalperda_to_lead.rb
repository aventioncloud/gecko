class AddTotalperdaToLead < ActiveRecord::Migration
  def change
    add_column :leads, :totalperda, :integer
  end
end
