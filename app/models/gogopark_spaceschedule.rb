class GogoparkSpaceschedule < ActiveRecord::Base
  belongs_to :gogopark_address
  
  validate :address_exists
  
  #validates :dayofweek, numericality: { only_integer: true }
  validates :end, presence: true
  validates :start, presence: true
  validates :price, presence: true, numericality: true
  
  private
  def address_exists
      # Validation will pass if the users exists
      valid = GogoparkAddress.exists?(self.gogopark_address_id)
      self.errors.add(:gogopark_address, "doesn't exist.") unless valid
  end

end
