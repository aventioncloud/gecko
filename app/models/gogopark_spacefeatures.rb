class GogoparkSpacefeatures < ActiveRecord::Base
  belongs_to :gogopark_address
  
  validate :address_exists
  
  validates :contactphone, presence: true
  validates :maxheight, presence: true, numericality: { only_integer: true }
  
  
  private
  def address_exists
      # Validation will pass if the users exists
      valid = GogoparkAddress.exists?(self.gogopark_address_id)
      self.errors.add(:gogopark_address, "doesn't exist.") unless valid
  end
  
end
