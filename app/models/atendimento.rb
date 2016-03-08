class Atendimento < ActiveRecord::Base
  has_paper_trail
  belongs_to :users
  
  before_create :record_number

  private
    def record_number
      self.leadnumber = 0
    end
end
