module V1
  class UserAPI < Base
    require_relative '../../lib/api/validations/email_value'
    namespace "user"
    authorizes_routes!
    
      helpers do
        def current_token; env['api.token']; end
        def warden; env['warden']; end

        def current_resource_owner
          User.find(current_token.resource_owner_id) if current_token
        end
      end
    
      desc 'Return current user, requires authentication'
      get 'me', authorize: ['read', 'User']  do
        @user = current_user
        ary = Array.new
        User.where("id = ?", @user['id']).find_each do |item|
            apartment!
            ary << {:id => item[:id],:name => item[:name], :email => item[:email], :roles => Role.find(item[:roles]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
        end
        ary
      end
      
      desc 'Return current user, requires authentication'
      params do
        requires :email, type: String
        optional :id, type: Integer
      end
      get 'validemail', authorize: ['read', 'User']  do
        if params[:id] == nil and params[:id] != nil
          User.exists?(:email => params[:email])
        else
          User.where("id != ? and email = ? and active = 'S'", params[:id], params[:email]).exists?
        end
      end
      
      desc 'Logout user'
      delete 'logout' do
        warden.logout
      end
    
      desc "Return all Users."
      params do
        optional :name, type: String
      end
      get '/', authorize: ['read', 'User'] do
        @user = current_user
        apartment!
        @role = Role.where(:name => 'Super Admin')
        
        ary = Array.new
        Apartment::Database.switch!("public")
        
        @search = ''
        if params[:name] != nil
          @search = params[:name]
        end
        
        if @role[0][:id] != @user["roles"]
          User.where("accounts_id = ? and roles != ? and active = 'S' and (? = '' or name like '%?%')", current_user["accounts_id"],  @role[0][:id], @search, @search).find_each do |item|
              apartment!
              ary << {:id => item[:id],:name => item[:name], :email => item[:email], :roles => Role.find(item[:roles]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
          end
        else
          User.where("accounts_id = ? and (? = '' or upper(name) like upper(?))" , current_user["accounts_id"], @search, '%'+@search+'%').find_each do |item|
              apartment!
              ary << {:id => item[:id],:name => item[:name], :active => item[:active], :email => item[:email], :roles => Role.find(item[:roles]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
          end
        end
        ary
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
        requires :name, type: String, desc: "User name."
        requires :email, email: true, type: String, desc: "E-mail User."
        requires :roles, type: Integer, desc: "Role User."
        requires :password, type: String, desc: "Password User."
      end
      post '', authorize: ['create', 'User'] do
        
        user = User.new(
              :email                 => params[:email],
              :password              => params[:password],
              :password_confirmation => params[:password],
              :name =>params[:name],
              :roles => params[:roles],
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
        requires :name, type: String, desc: "User name."
        requires :email, type: String, desc: "E-mail User."
        requires :roles, type: Integer, desc: "Role User."
        optional :password, type: String, desc: "Password User."
      end
      put ':id', authorize: ['create', 'User']  do
       
       if params[:password] != nil and params[:password] != ''
        User.find(params[:id]).update({
          name: params[:name],
          email: params[:email],
          roles: params[:roles],
          password: params[:password],
          password_confirmation: params[:password]
        })
       else
        User.find(params[:id]).update({
          name: params[:name],
          email: params[:email],
          roles: params[:roles]
        })
       end
      end
      
      desc "Delete a User."
      params do
        requires :id, type: String, desc: "User ID."
      end
      delete ':id', authorize: ['delete', 'User']  do
        guard!
        User.find(params[:id]).update(active: 'N')
      end
      
      desc "Active a User."
      params do
        requires :id, type: String, desc: "User ID."
      end
      post ':id', authorize: ['create', 'User']  do
        guard!
        User.find(params[:id]).update(active: 'S')
      end
  end
end