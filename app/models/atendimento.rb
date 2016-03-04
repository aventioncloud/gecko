class Atendimento < ActiveRecord::Base
  has_paper_trail
  belongs_to :users
end
