class Atendimento < ActiveRecord::Base
  has_paper_trail
  belongs_to :user, foreign_key: :users_id, primary_key: :id

  before_create :record_number

  private
    def record_number
      self.leadnumber = 0
    end
end
