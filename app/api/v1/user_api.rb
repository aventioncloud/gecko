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
            #apartment!
            ary << {:id => item[:id],:name => item[:name], :email => item[:email], :roles => Role.find(item[:roles]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M"), :isemail => item[:isemail], :islead => item[:islead], :celular => item[:celular], :group_id => item[:groups_id], :accounts => item[:accounts_id] }
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

      desc "Audit all User."
      params do
        optional :id, type: Integer, desc: "ID do User."
        optional :date_sta, type: String, desc: "Date Start."
        optional :date_end, type: String, desc: "Date End."
      end
      get 'audit', authorize: ['all', 'Super Admin'] do
        apartment!
        if params[:id] != nil and params[:id] != 0
          User.find(params[:id]).versions
        else
          data_start = Date.parse(params[:date_sta])
          data_end = Date.parse(params[:date_end])
          #         filter += " and leads.created_at::timestamp::date between '"+params[:data]+"' and '"+params[:data_end]+"'"
          PaperTrail::Version
              .where("item_type = 'User' and created_at::timestamp::date between ? and ?",data_start,data_end)
              .order('id DESC')
              .limit(10)
          #Lead.versions.between(data_start, data_end)
        end
      end

      desc "Compare Version Audit."
      params do
        optional :id, type: Integer, desc: "ID do User."
        requires :version_id, type: Integer, desc: "Version ID"
      end
      get 'compare', authorize: ['all', 'Super Admin'] do
        apartment!
        content_1 = User.find(params[:id])
        content_2 = content_1.versions.find(params[:version_id]).reify
        #changes = Diffy::SplitDiff.new(content_1.to_json, content_2.to_json, :format => :html)
        #changes.to_s.present? ? changes.to_s(:html).html_safe : 'No Changes'
        #content_1.to_json

        changes = Diffy::Diff.new(content_2.to_json, content_1.to_json,
                                     include_plus_and_minus_in_html: true,
                                     include_diff_info: false)
        changes.to_s.present? ? changes.to_s(:html).html_safe : 'No Changes'

      end

      desc "Build Graph Queue."
      params do
        requires :tipo, type: String, desc: "PJ or PF."
      end
      get 'graphqueue', authorize: ['read', 'User'] do
        apartment!
        if params[:tipo] == 'PJ'
         Atendimento.where(:ispj => 'S').joins(:user).select("name, leadnumber")
        else
          Atendimento.where(:ispf => 'S').joins(:user).select("name, leadnumber")
        end
      end

      desc "Build Graph Status."
      params do
        requires :user_id, type: Integer, desc: "ID User"
      end
      get 'graphstatus', authorize: ['read', 'User'] do
        apartment!
        user = User.find(params[:user_id]) rescue nil
        if !user.nil?
          items = Array.new
          leads = Lead.where(:user_id => params[:user_id]).joins(:leadstatus).group('leadstatus_id').count('id')
          items << {:item => 'Perdas', :value => user.totalperda}
          leads.each do |item|
            items << {:item => LeadStatus.find(item[0]).name, :value => item[1]}
          end
          items
        end
      end

      desc "Return all Version User Atendimento."
      params do
        optional :id, type: Integer, desc: "ID do User."
      end
      get 'history', authorize: ['read', 'User'] do
        apartment!
        item = Atendimento.where(:users_id => params[:id]).first rescue nil
        if !item.nil?
          #atendimento = PaperTrail::Version
          #    .where("item_type = 'Atendimento' and item_id = ?",params[:id])
          #    .order('id DESC')
          #    .limit(10)
          #atendimento
          Atendimento.find(item.id).versions
        end
      end

      desc "Return all Active History."
      params do
        requires :id, type: Integer, desc: "ID do User."
      end
      get 'historyatendimento', authorize: ['read', 'User'] do
        apartment!
        @atendimento = Atendimento.where(:users_id => params[:id]).first
        AtendimentoActive.joins(:user).joins(:atendimento => [:user]).select("atendimento_actives.*, users.name as owner, users_atendimentos.name as users, to_char(atendimento_actives.created_at, 'DD/MM/YYYY HH:mm') as data").limit(10)
      end

      desc "Import a User."
      post 'import', authorize: ['create', 'User'] do
        apartment!
        docfile = params[:file]

        attachment = {
            :filename => docfile[:filename],
            :type => docfile[:type],
            :headers => docfile[:head],
            :tempfile => docfile[:tempfile]
        }
        @user = current_user
        importfile = ImportFile.create(docfile: ActionDispatch::Http::UploadedFile.new(attachment), status: 'User')
        filename = Rails.root.join("public", "importtmp/"+importfile.docfile_file_name)

        options = {:col_sep => ";", :row_sep => "\n", :file_encoding => 'ISO-8859-1'}
        ary = Array.new
        senha = "trocar12!"
        role = 4 #usuario

        SmarterCSV.process(filename, options) do |array|
          apartment!
          groupcheck = Group.where('code = ? and code is not null',array.first[:groupid]).first rescue nil
          group_id = nil
          if !groupcheck.nil?
            group_id = groupcheck.id
          end
          if !User.where(:code => array.first[:code]).exists?
            user = User.create(groups_id: group_id, name: array.first[:name], email: array.first[:email], password: senha, password_confirmation: senha, roles: role, isemail: 'true', islead: 'false', accounts_id: @user["accounts_id"], code: array.first[:code])
            if user.save
              ary << {code: '1', message: 'sucesse', user: array.first[:name]}
            else
              ary << {code: '2', message: 'error', user: array.first[:name], error: user.errors.full_messages}
            end
          else
            group = User.where(:code => array.first[:code]).first.update(name: array.first[:name])
            ary << {code: '1', message: 'sucesse', group: array.first[:name]}
          end
        end
        ary
      end

      desc 'Link user product'
      params do
        requires :user_id, type: Integer
        requires :products, type: String
      end
      post 'linkproduct', authorize: ['read', 'User']  do
        Apartment::Database.switch!("public")
        @user = User.find(params[:user_id]) rescue { :error => "Usuário não encontrado." }
        if defined?(@user.id)
          apartment!
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

      desc "Active atendimento a User."
      params do
        requires :user_id, type: String, desc: "User ID."
        requires :atendimento, type: String, desc: "Atendimento(C => Chat, F => Fisica, J => Juridica) ID."
        requires :active, type: String, desc: "User ID."
      end
      post 'atendimento', authorize: ['create', 'User']  do
        @user = current_user rescue nil
        apartment!
        PaperTrail.whodunnit = @user["email"]
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
          AtendimentoActive.create(tipo: 'C', users_id: @user["id"], atendimentos_id: id, status: ativostatus).save
          Atendimento.find(id).update(ischat: ativostatus, leadnumber: 0)
        elsif params[:atendimento] == 'F'
          AtendimentoActive.create(tipo: 'F', users_id: @user["id"], atendimentos_id: id, status: ativostatus).save
          Atendimento.find(id).update(ispf: ativostatus, leadnumber: 0)
        elsif params[:atendimento] == 'J'
          AtendimentoActive.create(tipo: 'J', users_id: @user["id"], atendimentos_id: id, status: ativostatus).save
          Atendimento.find(id).update(ispj: ativostatus, leadnumber: 0)
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
        ary = Array.new
        ary = Array.new
        Apartment::Database.switch!("public")
        @rolelist = Role.all()#.find(item[:roles])
        @search = ''
        if params[:name] != nil
          @search = params[:name]
        end

        apartment!
        @atendimentolist = Atendimento.all()
        @grouplist = Group.all()

        if 1 != @user["roles"] and 2 != @user["roles"]
          User.where("accounts_id = ? and roles != ? and active = 'S' and (? = '' or name like '%?%')", current_user["accounts_id"],  @role[0][:id], @search, @search).find_each do |item|
              @role = @rolelist.detect{|w| w.id == item[:roles]}
              apartment!
              @atendimento = @atendimentolist.detect{|w| w.users_id == item[:id]}
              @group = @grouplist.detect{|w| w.id == item[:groups_id]}
              #@products = UsersProducts.joins(:products).select("products.name, products.id, users_products.id as up").where(:user_id => item[:id])
              ary << {:id => item[:id],:name => item[:name], :active => item[:active],
                      :email => item[:email], :roles => @role, :products => nil,
                      :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M"),
                      :isemail => item[:isemail], :islead => item[:islead], :celular => item[:celular],
                      :group_id => item[:groups_id], :atendimento => Atendimento.where(:users_id => item[:groups_id]).first, :group => @group }
          end
        elsif 2 == @user["roles"]
          User.where("accounts_id = ? and active = 'S' and (? = '' or upper(name) like upper(?))" , current_user["accounts_id"], @search, '%'+@search+'%').find_each do |item|
              @role = @rolelist.detect{|w| w.id == item[:roles]}
             apartment!
              @atendimentos = @atendimentolist.detect{|w| w.users_id == item[:id]}
              @groups = @grouplist.detect{|w| w.id == item[:groups_id]}
               #@products = UsersProducts.joins(:products).select("products.name, products.id, users_products.id as up").where(:user_id => item[:id])
              ary << {:id => item[:id],:name => item[:name], :active => item[:active], :email => item[:email],
                    :roles => @role, :products => nil, :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M"),
                    :isemail => item[:isemail], :islead => item[:islead], :celular => item[:celular],
                    :group_id => item[:groups_id], :atendimento => @atendimentos, :group => @groups }
          end
        else
          User.where("accounts_id = ? and (? = '' or upper(name) like upper(?))" , current_user["accounts_id"], @search, '%'+@search+'%').find_each do |item|
              @role = @rolelist.detect{|w| w.id == item[:roles]}
             apartment!
              @atendimentos = @atendimentolist.detect{|w| w.users_id == item[:id]}
              @groups = @grouplist.detect{|w| w.id == item[:groups_id]}
               #@products = UsersProducts.joins(:products).select("products.name, products.id, users_products.id as up").where(:user_id => item[:id])
              ary << {:id => item[:id],:name => item[:name], :active => item[:active], :email => item[:email],
                    :roles => @role, :products => nil, :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M"),
                    :isemail => item[:isemail], :islead => item[:islead], :celular => item[:celular],
                    :group_id => item[:groups_id], :atendimento => @atendimentos, :group => @groups }
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
        @user = current_user rescue nil
        PaperTrail.whodunnit = @user["email"]
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
        @user = current_user rescue nil
        PaperTrail.whodunnit = @user["email"]
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
        @user = current_user rescue nil
        PaperTrail.whodunnit = @user["email"]
        User.find(params[:id]).update(active: 'N')
      end

      desc "Active a User."
      params do
        requires :id, type: String, desc: "User ID."
      end
      post ':id', authorize: ['create', 'User']  do
        @user = current_user rescue nil
        PaperTrail.whodunnit = @user["email"]
        User.find(params[:id]).update(active: 'S')
      end
  end
end
