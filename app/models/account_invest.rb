class AccountInvest < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :banks
  
  before_destroy :destroy_account
  after_create :create_account
  
  private
  
  def create_account
      AccountShared.new(:users_id => self.users_id, :account_invests_id => self.id, :write => true).save
  end
  
  def destroy_account
      AccountShared.destroy_all(:account_invests_id => self.id)
  end
end
