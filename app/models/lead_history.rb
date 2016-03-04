class LeadHistory < ActiveRecord::Base
  belongs_to :leadstatus
  belongs_to :user
  belongs_to :lead
  belongs_to :leadfile, :class_name => 'LeadFile', foreign_key: :lead_file_id, primary_key: :id
end
