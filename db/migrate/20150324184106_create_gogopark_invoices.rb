class CreateGogoparkInvoices < ActiveRecord::Migration
  def change
    create_table :gogopark_invoices do |t|
      t.references :users, index: true
      t.references :gogopark_spaceschedule, index: true
      t.float :price
      t.datetime :dateref

      t.timestamps
    end
  end
end
