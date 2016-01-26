class AccountShared < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :account_invests
  belongs_to :users
  belongs_to :platform_groups
end
