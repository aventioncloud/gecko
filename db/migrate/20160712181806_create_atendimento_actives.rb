class CreateAtendimentoActives < ActiveRecord::Migration
  def change
    create_table :atendimento_actives do |t|
      t.references :atendimentos, index: true
      t.references :users, index: true

      t.timestamps
    end
  end
end
