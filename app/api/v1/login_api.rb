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
      
      desc 'Logout user'
      delete 'logout' do
        warden.logout
      end
  end
end