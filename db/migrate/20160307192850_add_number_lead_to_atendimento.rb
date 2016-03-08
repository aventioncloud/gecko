class AddNumberLeadToAtendimento < ActiveRecord::Migration
  def change
    add_column :atendimentos, :leadnumber, :Integer
  end
end
