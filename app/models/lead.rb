class Lead < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :leadstatus, :class_name => 'LeadStatus', foreign_key: :leadstatus_id, primary_key: :id
  belongs_to :contact, foreign_key: :contact_id, primary_key: :id
  
end
