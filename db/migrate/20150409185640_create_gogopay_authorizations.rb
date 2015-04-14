class CreateGogopayAuthorizations < ActiveRecord::Migration
  def change
    create_table :gogopay_authorizations do |t|
      t.references :gogopay_creditcards, index: true
      t.references :gogopay_transactions, index: true
      t.string :last_for_digits
      t.decimal :amount

      t.timestamps
    end
  end
end
