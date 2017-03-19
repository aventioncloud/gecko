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

  def self.send_pushapp(message, players)
    params = {"app_id" => "f68def16-3d8b-413a-832c-546f77f84728", 
              "contents" => {"en" => message},
              "small_icon" => "icon",
              "include_player_ids" => players
        }
    uri = URI.parse('https://onesignal.com/api/v1/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type'  => 'application/json;charset=utf-8',
                                  'Authorization' => "Basic NzQ1MmI1MTEtZjY5OS00YTk2LWFkNzUtZDZmY2VmYTkwMDQ5")
    request.body = params.as_json.to_json
    response = http.request(request)
  end
  
  private
    def record_active
      self.active = 'S'
    end
end
