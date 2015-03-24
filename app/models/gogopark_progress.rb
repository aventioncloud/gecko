class GogoparkProgress < ActiveRecord::Base
  belongs_to :users
  belongs_to :gogopark_spaceschedule
  
  validates_associated :users
  validates_associated :gogopark_spaceschedule
  
  
  
end
