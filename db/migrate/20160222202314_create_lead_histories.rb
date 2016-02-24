class CreateLeadHistories < ActiveRecord::Migration
  def change
    create_table :lead_histories do |t|
      t.references :leadstatus, index: true
      t.references :user, index: true
      t.string :comment

      t.timestamps
    end
  end
end
