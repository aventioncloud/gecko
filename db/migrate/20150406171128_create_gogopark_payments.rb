class CreateGogoparkPayments < ActiveRecord::Migration
  def change
    create_table :gogopark_payments do |t|
      t.references :gogopark_progress, index: true
      t.references :gogopark_invoice, index: true
      t.string :typepayment
      t.datetime :paidoff
      t.datetime :conferred
      t.integer :usersconferred

      t.timestamps
    end
  end
end
