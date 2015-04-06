class GogoparkPayment < ActiveRecord::Base
  belongs_to :gogopark_progress
  belongs_to :gogopark_invoice
end
