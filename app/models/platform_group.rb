class PlatformGroup < ActiveRecord::Base
  belongs_to :users
  
  validates :name, presence: true
  validates_associated :users
end
