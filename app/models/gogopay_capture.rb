class GogopayCapture < ActiveRecord::Base
  belongs_to :gogopay_authorizations
  belongs_to :gogopay_transactions
end
