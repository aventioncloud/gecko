class PlatformGroup < ActiveRecord::Base
  has_one :users
  
  before_destroy :destroy_group
  
  validates :name, presence: true
  validates :users_id, presence: true
  
  validate :users_exists

  private
  def users_exists
      # Validation will pass if the users exists
      valid = User.exists?(self.users_id)
      self.errors.add(:users, "doesn't exist.") unless valid
  end
  
  def destroy_group
      PlatformTeam.destroy_all(:platform_group_id => self.id)
  end
end
