class PlatformTeam < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :platform_group
  belongs_to :users
  
  validate :users_exists
  validate :group_exists
  
  private
  def users_exists
      # Validation will pass if the users exists
      valid = User.exists?(self.users_id)
      self.errors.add(:users, "doesn't exist.") unless valid
  end
  
  def group_exists
    # Validation will pass if the users exists
    valid = PlatformGroup.exists?(self.platform_group_id)
    self.errors.add(:platform_group, "doesn't exist.") unless valid
  end
end
