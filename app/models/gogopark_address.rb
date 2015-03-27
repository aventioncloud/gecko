class GogoparkAddress < ActiveRecord::Base
  belongs_to :users
  belongs_to :platform_group
  belongs_to :cidade
  
  validate :users_exists
  validate :group_exists
  validate :cidade_exists
  
  validates :address, presence: true
  validates :numberhome, presence: true, numericality: { only_integer: true }
  validates :neighborhood, presence: true
  validates :postcode, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  
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
  
  def cidade_exists
    # Validation will pass if the users exists
    valid = Cidade.exists?(self.cidade_id)
    self.errors.add(:cidade, "doesn't exist.") unless valid
  end
  
end
