class GogoparkSpaceverifications < ActiveRecord::Base
  belongs_to :users
  belongs_to :gogopark_address
  has_many :gogopark_address
  
  #validates_associated :users
  #validates_associated :gogopark_space
  
  #validates :spaceverications, presence: true
  #validates :spaceverified, presence: true
  #validates :description, presence: true
  
end
