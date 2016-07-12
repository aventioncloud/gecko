class AddStatusToAtendimentoActive < ActiveRecord::Migration
  def change
    add_column :atendimento_actives, :status, :string
  end
end
