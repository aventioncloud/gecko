class GogoparkProgress < ActiveRecord::Base
  belongs_to :users
  belongs_to :gogopark_spaceschedule
  
  #validates_associated :users
  #validates_associated :gogopark_spaceschedule
  
  validates :price, presence: true, numericality: true
  validates :checkin, presence: true
  
end