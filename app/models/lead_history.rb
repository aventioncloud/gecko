class LeadHistory < ActiveRecord::Base
  belongs_to :leadstatus
  belongs_to :user
  belongs_to :lead
end
