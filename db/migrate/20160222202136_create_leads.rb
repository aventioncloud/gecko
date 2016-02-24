class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.references :user, index: true
      t.references :leadstatus, index: true
      t.references :contact, index: true
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
