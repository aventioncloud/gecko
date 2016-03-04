class Lead < ActiveRecord::Base
  has_paper_trail
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :leadstatus, :class_name => 'LeadStatus', foreign_key: :leadstatus_id, primary_key: :id
  belongs_to :contact, foreign_key: :contact_id, primary_key: :id
  
  has_attached_file :docfile, :path => ":rails_root/public/docfile/:filename"
  validates_attachment_file_name :docfile, :matches => [/doc\Z/, /pdf\Z/, /docx\Z/]
  
  after_destroy :clear_detroy
  
  
  private
  def clear_detroy
    LeadProduct.where(:lead_id => self.id).destroy_all
    #LeadFile.where(:lead_id => self.id).destroy_all
    LeadHistory.where(:lead_id => self.id).destroy_all
  end
end
