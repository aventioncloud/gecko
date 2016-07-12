class AtendimentoActive < ActiveRecord::Base
  belongs_to :atendimento, foreign_key: :atendimentos_id, primary_key: :id
  belongs_to :user, foreign_key: :users_id, primary_key: :id
end
