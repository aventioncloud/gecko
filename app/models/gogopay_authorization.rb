class GogopayAuthorization < ActiveRecord::Base
  belongs_to :gogopay_creditcards
  belongs_to :gogopay_transactions
end
