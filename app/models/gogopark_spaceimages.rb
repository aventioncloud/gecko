class GogoparkSpaceimages < ActiveRecord::Base
  belongs_to :gogopark_space
  
  validates_associated :gogopark_space
  
  validates :filename, presence: true
  validates :description, presence: true
  
end
