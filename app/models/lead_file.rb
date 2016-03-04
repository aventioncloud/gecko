class LeadFile < ActiveRecord::Base
    
  has_attached_file :docfile, :path => ":rails_root/public/docfile/:filename"
  validates_attachment_file_name :docfile, :matches => [/doc\Z/, /pdf\Z/, /docx\Z/]
end
