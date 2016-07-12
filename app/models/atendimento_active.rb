class AtendimentoActive < ActiveRecord::Base
  belongs_to :atendimentos
  belongs_to :users
end
