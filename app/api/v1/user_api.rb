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
      get 'me' do
        guard!
        @user = current_user
        ary = Array.new
        User.where("id = ?", @user['id']).find_each do |item|
            apartment!
            ary << {:id => item[:id],:name => item[:name], :email => item[:email], :roles => Role.find(item[:roles]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M"), :isemail => item[:isemail], :islead => item[:islead], :celular => item[:celular], :group_id => item[:groups_id] }
        end
        ary
      end
      
      desc 'Return current user, requires authentication'
      params do
        requires :email, type: String
        optional :id, type: Integer
      end
      get 'validemail', authorize: ['read', 'User']  do
        if params[:id] == nil or params[:id] != 0
          User.exists?(:email => params[:email]) ? 1 : 0
        else
          User.where("id != ? and email = ? and active = 'S'", params[:id], params[:email]).exists? ? 1 : 0
        end
      end
      
      desc 'Link user product'
      params do
        requires :user_id, type: Integer
        requires :products, type: String
      end
      post 'linkproduct', authorize: ['read', 'User']  do
        @user = User.find(params[:user_id]) rescue { :error => "Usuário não encontrado." }
        if defined?(@user.id)
          UsersProducts.where(:user_id => @user.id).destroy_all
          result = params[:products].split(/,/)
          result.each do |item|
             @productitem = Product.find(item) rescue { :error => "Produto não encontrado." }
             #binding.pry
             if defined?(@productitem.id)
                userproduct = UsersProducts.new(:user_id => @user.id, :product_id => @productitem.id)
                if userproduct.save
                  userproduct
                else
                  userproduct.errors.full_messages
                end
              else
                @productitem
             end
          end
        else
          @user
        end
      end
      
      desc 'Logout user'
      delete 'logout' do
        warden.logout
      end
      
      desc "Active atendimento a User."
      params do
        requires :user_id, type: String, desc: "User ID."
        requires :atendimento, type: String, desc: "Atendimento(C => Chat, F => Fisica, J => Juridica) ID."
        requires :active, type: String, desc: "User ID."
      end
      post 'atendimento', authorize: ['create', 'User']  do
        apartment!
        @atendimento = Atendimento.where(:users_id => params[:user_id]).first
        id = 0
        if @atendimento == nil
          atendimentoitem = Atendimento.new(:users_id => params[:user_id])
          atendimentoitem.save
          id = atendimentoitem.id
        else
          id = @atendimento.id
        end
        
        ativostatus = nil
        if params[:active] == 'S'
          ativostatus = 'S'
        end
        
        if params[:atendimento] == 'C'
          Atendimento.find(id).update(ischat: ativostatus)
        elsif params[:atendimento] == 'F'
          Atendimento.find(id).update(ispf: ativostatus)
        elsif params[:atendimento] == 'J'
          Atendimento.find(id).update(ispj: ativostatus)
        else
          { :error => "Tipo de atendimento não encontrado." }
        end
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
              ary << {:id => item[:id],:name => item[:name], :active => item[:active], :email => item[:email], :roles => Role.find(item[:roles]), :products => UsersProducts.joins(:products).select("products.name, products.id, users_products.id as up").where(:user_id => item[:id]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M"), :isemail => item[:isemail], :islead => item[:islead], :celular => item[:celular], :group_id => item[:groups_id], :atendimento => Atendimento.where(:users_id => item[:id]).first, :group => Group.where(:id => item[:groups_id]).first }
          end
        else
          User.where("accounts_id = ? and (? = '' or upper(name) like upper(?))" , current_user["accounts_id"], @search, '%'+@search+'%').find_each do |item|
              apartment!
              ary << {:id => item[:id],:name => item[:name], :active => item[:active], :email => item[:email], :roles => Role.find(item[:roles]), :products => UsersProducts.joins(:products).select("products.name, products.id, users_products.id as up").where(:user_id => item[:id]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M"), :isemail => item[:isemail], :islead => item[:islead], :celular => item[:celular], :group_id => item[:groups_id], :atendimento => Atendimento.where(:users_id => item[:id]).first, :group => Group.where(:id => item[:groups_id]).first }
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
          @useritem = User.find(params[:id]) rescue nil
          apartment!
          @user = {:id => @useritem.id, :name => @useritem.name, :email => @useritem.email, :created_at => @useritem.created_at, :roles => @useritem.roles, :products => UsersProducts.joins(:products).select("products.name, products.id, users_products.id as up").where(:user_id => params[:id]), :isemail => @useritem.isemail, :islead => @useritem.islead, :celular => @useritem.celular, :group_id => @useritem.groups_id}
          @user
        end
      end
      
      desc "Create a user."
      params do
        requires :name, type: String, desc: "User name."
        requires :email, email: true, type: String, desc: "E-mail User."
        requires :roles, type: Integer, desc: "Role User."
        requires :password, type: String, desc: "Password User."
        requires :group_id, type: Integer, desc: "Group User."
        optional :isemail, type: String, desc: "Is e-mail(S or N)."
        optional :islead, type: String, desc: "Is lead 20(S or N)."
        optional :celular, type: String, desc: "User Phone."
      end
      post '', authorize: ['create', 'User'] do
        
        user = User.new(
              :email                 => params[:email],
              :password              => params[:password],
              :password_confirmation => params[:password],
              :name =>params[:name],
              :roles => params[:roles],
              :groups_id => params[:group_id],
              :isemail => params[:isemail],
              :islead => params[:islead],
              :celular => params[:celular],
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
        requires :group_id, type: Integer, desc: "Group User."
        optional :password, type: String, desc: "Password User."
        optional :isemail, type: String, desc: "Is e-mail(S or N)."
        optional :islead, type: String, desc: "Is lead 20(S or N)."
        optional :celular, type: String, desc: "User Phone."
      end
      put ':id', authorize: ['create', 'User']  do
       
       if params[:password] != nil and params[:password] != ''
        User.find(params[:id]).update({
          name: params[:name],
          email: params[:email],
          roles: params[:roles],
          groups_id: params[:group_id],
          isemail: params[:isemail],
          islead: params[:islead],
          celular: params[:celular],
          password: params[:password],
          password_confirmation: params[:password]
        })
       else
        User.find(params[:id]).update({
          name: params[:name],
          email: params[:email],
          roles: params[:roles],
          groups_id: params[:group_id],
          isemail: params[:isemail],
          islead: params[:islead],
          celular: params[:celular],
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