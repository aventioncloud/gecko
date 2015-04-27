class SubdomainPresent
  def self.matches?(request)
    request.subdomain.present?
  end
end

class SubdomainBlank
  def self.matches?(request)
    request.subdomain.blank?
  end
end
Oauth2ApiSample::Application.routes.draw do
  
  #resources :welcomes
  #resources :user_session

  constraints(SubdomainPresent) do
    use_doorkeeper
    devise_for :users
    mount ApplicationAPI => '/api'
  end

  constraints(SubdomainBlank) do
    root 'pages#welcome'
    resources :accounts, only: [:new, :create]
  end
  

  
  #root 'pages#welcome'

  #get "/pages/:action", :controller => :pages
end
