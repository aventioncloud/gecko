class GogoparkSpaceimages < ActiveRecord::Base
  has_and_belongs_to_many :gogopark_address
  
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "120x90#" },
                  :path => ':rails_root/public/images/gogoparkaddress/:id-:basename-:style.:extension',
                  :url => '/images/gogoparkaddress/:id-:basename-:style.:extension'
  
  validates_attachment :image,
                        :content_type => { :content_type => ['image/jpg', 'image/png'] },
                        :presence => true
  
  #validates_associated :gogopark_space
  
  #validates :description, presence: true
  
  def image_remote_url=(url_value)
    self.image = URI.parse(url_value) unless url_value.blank?
    super
  end
end
