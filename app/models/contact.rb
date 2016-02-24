class Contact < ActiveRecord::Base

  belongs_to :lead

  before_create :record_active

  private
    def record_active
      self.active = 'S'
    end
end
