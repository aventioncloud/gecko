class CreateAtendimentos < ActiveRecord::Migration
  def change
    create_table :atendimentos do |t|
      t.references :users, index: true
      t.string :ischat
      t.string :ispf
      t.string :ispj

      t.timestamps
    end
  end
end
