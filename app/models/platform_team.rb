class PlatformTeam < ActiveRecord::Base
  belongs_to :platform_group
  belongs_to :users
  
  validates_associated :platform_group
  validates_associated :users
end
