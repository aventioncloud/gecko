class GogoparkSpacefeatures < ActiveRecord::Base
  belongs_to :gogopark_space
  
  validates_associated :gogopark_space
  
  validates :contactphone, presence: true
  validates :scheduleprivacy, presence: true
  validates :maxheight, presence: true, numericality: { only_integer: true }
  
end
