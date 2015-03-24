class GogoparkSpace < ActiveRecord::Base
  belongs_to :gogopark_address
  
  validates_associated :gogopark_address
  
  validates :term, presence: true
  validates :type, presence: true
  validates :size, presence: true
  validates :description, presence: true
end
