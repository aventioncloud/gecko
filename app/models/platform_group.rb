class PlatformGroup < ActiveRecord::Base
  has_paper_trail
  
  has_one :users
  
  before_destroy :destroy_group
  after_create :create_group
  
  validates :name, presence: true
  validates :users_id, presence: true
  
  validate :users_exists

  private
  def users_exists
      # Validation will pass if the users exists
      valid = User.exists?(self.users_id)
      self.errors.add(:users, "doesn't exist.") unless valid
  end
  
  def create_group
      PlatformTeam.new(:platform_group_id => self.id, :users_id => self.users_id, :default => true).save
  end
  
  def destroy_group
      PlatformTeam.destroy_all(:platform_group_id => self.id)
  end
end
