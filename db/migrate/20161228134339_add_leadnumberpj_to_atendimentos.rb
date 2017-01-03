class AddLeadnumberpjToAtendimentos < ActiveRecord::Migration
  def change
    add_column :atendimentos, :leadnumberpj, :integer
  end
end
