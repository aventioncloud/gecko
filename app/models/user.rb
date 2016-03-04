class User < ActiveRecord::Base
  has_paper_trail
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  attr_accessor :created_at_format
  
  has_many :lead, class_name: "Lead",
                            foreign_key: "user_id"
                            
  has_many :atendimento, class_name: "Atendimento",
                            foreign_key: "users_id"
                            
  has_many :users_products, class_name: "UsersProducts",
                              foreign_key: "user_id"
  
  has_and_belongs_to_many :products
         
  after_save :clear_cache
  before_create :record_active
  
  after_find do |user|
    #self.created_at = created_at.strftime("%m/%d/%Y")
  end
  
  def clear_cache
    #$redis.del "gecko_users"
  end
  
  private
    def record_active
      self.active = 'S'
    end
end
