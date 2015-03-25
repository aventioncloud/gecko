class GogoparkSpaceschedule < ActiveRecord::Base
  belongs_to :gogopark_space
  
  validates_associated :gogopark_space
  
  validates :dateref, presence: true
  validates :dayofweek, presence: true, numericality: { only_integer: true }
  validates :end, presence: true
  validates :start, presence: true
  validates :price, presence: true, numericality: true

end
