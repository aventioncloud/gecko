class CreateAccountInvests < ActiveRecord::Migration
  def change
    create_table :account_invests do |t|
      t.string :title
      t.references :banks, index: true
      t.integer :account
      t.integer :numberapplication
      t.date :startdate
      t.date :enddate
      t.date :shortage
      t.decimal :indexador
      t.boolean :iof
      t.decimal :value

      t.timestamps
    end
  end
end
