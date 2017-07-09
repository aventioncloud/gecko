class CreateLeadRemarkeds < ActiveRecord::Migration
  def change
    create_table :lead_remarkeds do |t|
      t.integer :status_id

      t.timestamps
    end
  end
end
