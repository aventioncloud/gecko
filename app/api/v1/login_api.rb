module V1
  class LoginAPI < Base
      namespace "login"
      
      helpers do
        def current_token; env['api.token']; end
        def warden; env['warden']; end

        def current_resource_owner
          User.find(current_token.resource_owner_id) if current_token
        end
      end

      desc "Login."
      params do
        requires :username, type: String, desc: "Bank name."
        requires :password, type: String, desc: "Number bank of Central Bank Brazil"
      end
      post do
        resource = User.find_by_email(params[:username])
        return {:code => 401, :error => 'Invalid Email Address or Password. Password is case sensitive.'} if resource.nil?

        bcrypt   = BCrypt::Password.new(resource.encrypted_password)
        password = BCrypt::Engine.hash_secret("#{params[:password]}#{resource.class.pepper}", bcrypt.salt)
        valid = Devise.secure_compare(password, resource.encrypted_password)
        # resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        if valid
          app = Doorkeeper::Application.where(uid: '03dbaf9c6f099e449a3d8ad2b4903727be168a56c2e890145037154ce66225bd').first
          access_token = Doorkeeper::AccessToken.create!({
            :application_id     => app.id,
            :resource_owner_id  => resource.id,
            :scopes             => 'all',
            :expires_in         => 1.year,
            :use_refresh_token  => Doorkeeper.configuration.refresh_token_enabled?
          })
          @token_response = Doorkeeper::OAuth::TokenResponse.new(access_token)
          {:code => 201, :token => @token_response.body, :user => resource}
        else
           {:code => 401, :error => 'Invalid Email Address or Password. Password is case sensitive.'}   
        end
      end
      
      desc 'Logout user'
      delete 'logout' do
        warden.logout
      end
  end
end