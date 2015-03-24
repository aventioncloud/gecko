class GogoparkAddress < ActiveRecord::Base
  belongs_to :users
  belongs_to :platform_group
  belongs_to :cidade
  
  validates_associated :users
  validates_associated :platform_group
  validates_associated :cidade
  
  validates :address, presence: true
  validates :numberhome, presence: true, numericality: { only_integer: true }
  validates :neighborhood, presence: true
  validates :postcode, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  
end
