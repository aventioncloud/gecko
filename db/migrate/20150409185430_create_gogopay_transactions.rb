class CreateGogopayTransactions < ActiveRecord::Migration
  def change
    create_table :gogopay_transactions do |t|
      t.references :users, index: true
      t.references :gogopay_creditcards, index: true
      t.string :tid

      t.timestamps
    end
  end
end
