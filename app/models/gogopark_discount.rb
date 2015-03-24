class GogoparkDiscount < ActiveRecord::Base
  belongs_to :platform_group
  belongs_to :users
  
  validates_associated :platform_group
  validates_associated :users
  
  validates :price, presence: true, numericality: true
  validates :typediscount, presence: true
  
end
