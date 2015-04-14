class CreateGogopayCaptures < ActiveRecord::Migration
  def change
    create_table :gogopay_captures do |t|
      t.references :gogopay_authorizations, index: true
      t.references :gogopay_transactions, index: true
      t.decimal :amount

      t.timestamps
    end
  end
end
