class GogopayTransaction < ActiveRecord::Base
  belongs_to :users
  belongs_to :gogopay_creditcards
end
