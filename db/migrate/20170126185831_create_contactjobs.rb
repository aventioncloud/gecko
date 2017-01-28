class CreateContactjobs < ActiveRecord::Migration
  def change
    create_table :contactjobs do |t|
      t.references :contact, index: true
      t.string :nome
      t.string :telefone
      t.string :sexo
      t.string :mae
      t.string :nasc
      t.string :obito
      t.string :veiculo
      t.string :iptu

      t.timestamps
    end
  end
end
