class Group < ActiveRecord::Base
  belongs_to :users
  
  before_create :record_active
  
  
  private
    def record_active
      self.active = 'S'
    end
end
