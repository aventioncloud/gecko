class CreateGogopayVoids < ActiveRecord::Migration
  def change
    create_table :gogopay_voids do |t|
      t.string :voidee_type
      t.references :gogopay_transactions, index: true

      t.timestamps
    end
  end
end
