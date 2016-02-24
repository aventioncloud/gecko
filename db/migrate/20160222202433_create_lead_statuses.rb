class CreateLeadStatuses < ActiveRecord::Migration
  def change
    create_table :lead_statuses do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
