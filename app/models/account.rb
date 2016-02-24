class Account < ActiveRecord::Base
  RESTRICTED_SUBDOMAINS = %w(www)

  belongs_to :owner, class_name: 'User'

  validates :owner, presence: true
  validates :subdomain, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[\w\-]+\Z/i, message: 'contains invalid characters' },
            exclusion: { in: RESTRICTED_SUBDOMAINS, message: 'restricted' }

  accepts_nested_attributes_for :owner

  before_validation :downcase_subdomain
  after_destroy :clear_user
  after_create :create_api

  private
  def downcase_subdomain
    self.subdomain = subdomain.try(:downcase)
  end
  
  def clear_user
    connection = ActiveRecord::Base.connection
    connection.execute("delete from users where accounts_id = #{self.id}") 
    #User.destroy_all(:accounts_id => self.id)
  end
  
  def create_api
    app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../config/application.yml', __FILE__)).read).result)[Rails.env]
    uri = "http://#{self.subdomain}.#{app_config['host']}:#{app_config['port']}/"
    
    Application.new(
      :name => self.subdomain,
      :uid => Doorkeeper::OAuth::Helpers::UniqueToken.generate,
      :secret => Doorkeeper::OAuth::Helpers::UniqueToken.generate,
      :redirect_uri => uri
      ).save
  end
  
end
