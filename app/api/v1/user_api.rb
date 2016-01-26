module V1
  class UserAPI < Base
    require_relative '../../lib/api/validations/email_value'
    namespace "user"
    authorizes_routes!
    
      desc 'Return current user, requires authentication'
      get 'me', authorize: ['read', 'User']  do
        current_user
      end
    
      desc "Return all Users."
      get '/', authorize: ['read', 'User'] do
        User.where(:accounts_id => current_user["accounts_id"])
      end
      
      desc "Return one user."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get '', authorize: ['read', 'User'] do
          Apartment::Database.switch!("public")
          @user = User.find(params[:id]) rescue nil
          @user
        end
      end
      
      desc "Create a user."
      params do
        requires :name, type: String, desc: "Group name."
        requires :email, email: true, type: String, desc: "E-mail User."
        requires :role_id, type: Integer, desc: "Role User."
        requires :password, type: String, desc: "Password User."
      end
      post '', authorize: ['create', 'User'] do
        
        user = User.new(
              :email                 => params[:email],
              :password              => params[:password],
              :password_confirmation => params[:password],
              :name =>params[:name],
              :roles => params[:role_id],
              :accounts_id => current_user["accounts_id"]
        )
        
        if user.save
            user
        else
            user.errors.full_messages
        end
      end
      
      desc "Update a User."
      params do
        requires :id, type: String, desc: "User ID."
        requires :name, type: String, desc: "Group name."
        requires :email, type: String, desc: "E-mail User."
        requires :role_id, type: Integer, desc: "Role User."
      end
      put ':id', authorize: ['create', 'User']  do
        guard!
        User.find(params[:id]).update({
          name: params[:name],
          email: params[:email],
          roles: params[:role_id]
        })
      end
      
      desc "Delete a User."
      params do
        requires :id, type: String, desc: "User ID."
      end
      delete ':id', authorize: ['delete', 'User']  do
        guard!
        User.find(params[:id]).destroy
      end
  end
end