class ImportFile < ActiveRecord::Base
  has_attached_file :docfile, :path => ":rails_root/public/importtmp/:filename"
  validates_attachment_file_name :docfile, :matches => [/csv\Z/, /txt\Z/]
end
