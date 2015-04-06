class GogoparkAddress < ActiveRecord::Base
  belongs_to :users
  belongs_to :platform_group
  has_many :cidade, class_name: "Cidade",
                      foreign_key: "id",
                      primary_key: "cidade_id"
                      
  has_many :gogopark_spaceverifications, class_name: "GogoparkSpaceverifications",
                      foreign_key: "gogopark_address_id"
                      
  has_many :gogopark_spaceimages, class_name: "GogoparkSpaceimages",
                      foreign_key: "gogopark_address_id"
                      
  belongs_to :gogopark_spaceimages

  validate :space_exists
  validate :cidade_exists
  
  after_create :address_created
  
  validates :address, presence: true
  validates :numberhome, presence: true, numericality: { only_integer: true }
  validates :neighborhood, presence: true
  validates :postcode, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  
  private
  
  def cidade_exists
    # Validation will pass if the users exists
    valid = Cidade.exists?(self.cidade_id)
    self.errors.add(:cidade, "doesn't exist.") unless valid
  end
  
  def space_exists
    # Validation will pass if the users exists
    valid = GogoparkSpace.exists?(self.gogopark_space_id)
    self.errors.add(:gogoparkspace, "doesn't exist.") unless valid
  end
  
  def address_created
    #binding.pry
    GogoparkSpaceverifications.create({
      gogopark_address_id: self.id,
      spaceverications: true,
      spaceverified: false,
      description: 'Espaço a ser verificado.'
    })
  end
  
end
