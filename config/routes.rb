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
    use_doorkeeper do
      # it accepts :authorizations, :tokens, :applications and :authorized_applications
      controllers :authorizations => 'custom_authorizations', :tokens => 'custom_token', :applications => 'custom_applications'
      #controllers :applications => 'custom_applications', :tokens => 'custom_token'
    end
    devise_for :users
    resources :pages
    root 'pages#welcome'
    mount ApplicationAPI => '/api'
    resources :documentation, only: [:index] do
      collection do
        get :o2c
        get :authorize
      end
    end
  end

  constraints(SubdomainBlank) do
    #root 'pages#welcome'
    resources :accounts, only: [:new, :create]
  end
  

  
  #root 'pages#welcome'

  #get "/pages/:action", :controller => :pages
end
