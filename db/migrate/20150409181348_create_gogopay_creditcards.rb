class CreateGogopayCreditcards < ActiveRecord::Migration
  def change
    create_table :gogopay_creditcards do |t|
      t.references :users, index: true
      t.string :name
      t.string :crypted_number
      t.string :token
      t.string :card_type
      t.string :street_address
      t.integer :city
      t.string :zip

      t.timestamps
    end
  end
end
