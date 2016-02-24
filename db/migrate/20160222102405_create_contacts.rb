class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :phone
      t.string :address
      t.string :number
      t.string :cpfcnpj
      t.string :city
      t.string :active
      t.string :zipcode
      t.string :email
      t.string :letter

      t.timestamps
    end
  end
end
