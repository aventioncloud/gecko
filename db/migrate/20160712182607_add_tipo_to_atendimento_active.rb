class AddTipoToAtendimentoActive < ActiveRecord::Migration
  def change
    add_column :atendimento_actives, :tipo, :string
  end
end
