module V1
  class LeadAPI < Base
      namespace "lead"
      
      require 'pusher'
      Pusher.url = "https://63230285f168f50e6200:55828354e0f70f99e33f@api.pusherapp.com/apps/183185"
    
      desc "Create Status Lead."
      params do
        requires :name, type: String, desc: "Name Status."
        requires :color, type: String, desc: "Color Status."
      end
      post "status", authorize: ['all', 'Super Admin'] do
        apartment!
        status = LeadStatus.new(
          :name => params[:name],
          :color => params[:name])
        if status.save
            status
        else
            status.errors.full_messages
        end
      end
      
      desc "Return all Lead."
      get 'status', authorize: ['read', 'Lead'] do
        apartment!
        
        LeadStatus.all
      end
      
      desc "Audit all Lead."
      params do
        optional :id, type: Integer, desc: "ID do Lead."
        optional :date_sta, type: String, desc: "Date Start."
        optional :date_end, type: String, desc: "Date End."
      end
      get 'audit', authorize: ['all', 'Super Admin'] do
        apartment!
        if params[:id] != nil and params[:id] != 0
          Lead.find(params[:id]).versions
        else
          data_start = Date.parse(params[:date_sta])
          data_end = Date.parse(params[:date_end])
          #         filter += " and leads.created_at::timestamp::date between '"+params[:data]+"' and '"+params[:data_end]+"'"
          PaperTrail::Version
              .where("item_type = 'Lead' and created_at::timestamp::date between ? and ?",data_start,data_end)
              .order('id DESC')
              .limit(10)
          #Lead.versions.between(data_start, data_end)
        end
      end
      
      desc "Compare Version Audit."
      params do
        optional :id, type: Integer, desc: "ID do Lead."
        requires :version_id, type: Integer, desc: "Version ID"
      end
      get 'compare', authorize: ['all', 'Super Admin'] do
        apartment!
        content_1 = Lead.find(params[:id])
        content_2 = content_1.versions.find(params[:version_id]).reify
        
        changes = Diffy::Diff.new(content_2.to_json, content_1.to_json, 
                                     include_plus_and_minus_in_html: true, 
                                     include_diff_info: false)
        changes.to_s.present? ? changes.to_s(:html).html_safe : 'No Changes'
        
      end
      
      desc "Change Status Lead."
      params do
        requires :id, type: Integer, desc: "ID do Lead."
        requires :status, type: Integer, desc: "ID do Status do Lead."
        optional :comment, type: String, desc: "String do Lead."
        optional :file_id, type: String, desc: "File do Lead."
      end
      post 'changestatus', authorize: ['read', 'Lead'] do
        apartment!
        @lead = Lead.joins(:contact).joins(:user).select("leads.*, contacts.email, users.email as user_email").find(params[:id]) rescue nil
        #binding.pry
        if @lead != nil
          @comment = CGI.unescapeHTML(params[:comment]).html_safe
          LeadHistory.create(leadstatus_id: params[:status], user_id: @lead.user_id, lead_id: params[:id], comment: @comment, lead_file_id: params[:file_id]).save
          Lead.find(params[:id]).update(:leadstatus_id => params[:status])
          filename = nil
          if params[:file_id] != nil and !params[:file_id].empty?
            filename = LeadFile.find(params[:file_id]).docfile_file_name rescue nil
          end
          if @comment != nil and !@comment.empty?
            LeadMailer.prospect(@lead.email, @lead.user_email, filename, @comment).deliver
          end
          { code: 400, mensage: 'sucesso'}
        end
      end
      
      desc "Change Consult Lead."
      params do
        requires :id, type: Integer, desc: "ID Lead."
        requires :user_id, type: Integer, desc: "ID User from Lead."
      end
      post 'changesconsult', authorize: ['create', 'Lead'] do
        @user = User.find(params[:user_id]) rescue nil
        apartment!
        @lead = Lead.joins(:contact).select("leads.*, contacts.email").find(params[:id]) rescue nil
        #binding.pry
        if @lead != nil and @user != nil
          Lead.find(params[:id]).update(:user_id => @user.id)
          LeadHistory.create(leadstatus_id: 1, user_id: params[:user_id], lead_id: params[:id]).save
          #Push
          
          Pusher.trigger('lead_channel', 'created', {
            message: 'Novo Lead cadastrado para você',
            user: @user.id,
            lead: @lead.id
          })
          
          if @user.isemail == 'true'
            LeadMailer.created(@user.email).deliver
          end
          { code: 400, mensage: 'sucesso', user: @user}
        else
          { code: 500, mensage: 'Lead or User not found.'}
        end
      end
      
      desc "History Lead."
      params do
        requires :id, type: Integer, desc: "ID do Lead."
        requires :status_id, type: Integer, desc: "Status do Lead. Send '0' to All result"
      end
      get 'history', authorize: ['read', 'Lead'] do
        apartment!
        LeadHistory.where(:lead_id => params[:id]).joins("LEFT JOIN lead_files ON lead_histories.lead_file_id = lead_files.id").select("lead_histories.*, lead_files.id as file_id, lead_files.docfile_file_name, to_char(lead_histories.created_at, 'DD/MM/YYYY HH:mm') as data").where("? = 0 or lead_histories.leadstatus_id = ?", params[:status_id], params[:status_id])
      end
      
      desc "Upload Lead."
      post 'upload' do
        apartment!
        docfile = params[:file]
        
        attachment = {
            :filename => docfile[:filename],
            :type => docfile[:type],
            :headers => docfile[:head],
            :tempfile => docfile[:tempfile]
        }
        
        lead = LeadFile.create(docfile: ActionDispatch::Http::UploadedFile.new(attachment))
        
        if lead.save
            lead
        else
            lead.errors.full_messages
        end
      end
      
      desc "Download Lead File."
      params do
        requires :id, type: Integer, desc: "ID File Lead."
      end
      get 'download_file' do
          file = LeadFile.find(params[:id])
          content_type "application/octet-stream"
          env['api.format'] = :binary
          header['Content-Disposition'] = "attachment; filename="+file.docfile_file_name
          File.open(Rails.root.join("public", "docfile/"+file.docfile_file_name)).read
      end
      
      desc "Job Create Lead."
      params do
        requires :tipo, type: String, desc: "Tipo Client(F => Pessoa Fisica, J => Pessoa Juridica, C => Chat)."
        requires :nome, type: String, desc: "Nome Client."
        requires :email, type: String, desc: "E-mail Client."
        optional :bairro, type: String, desc: "Bairro Client."
        requires :telefone, type: String, desc: "Telefone Client."
        optional :celular, type: String, desc: "Celular Client."
        requires :cidade, type: String, desc: "Cidade Client."
        requires :titulo, type: String, desc: "Titulo Lead."
        requires :descricao, type: String, desc: "Descricao do Lead."
        requires :productcollection, type: String, desc: "Produto do Lead."
        optional :urlchat, type: String, desc: "URL Chat atendimento."
        optional :numberproduct, type: Integer, desc: "Number product Lead"
      end
      post 'job', authorize: ['read', 'Lead'] do
        apartment!
        startstatus = 1
        user = 0
        email = ""
        isemail = "N"
        #binding.pry
        
        if params[:numberproduct] != nil and params[:numberproduct] != 0 and params[:numberproduct] >= 20
           usersflags = User.joins(:atendimento).joins(:users_products).select("users.id").where("active = 'S' and islead = 'true' and ((? = 'F' and atendimentos.ispf = 'S') or (? = 'J' and atendimentos.ispj = 'S') or (? = 'C' and atendimentos.ischat = 'S')) and (users_products.product_id = ?)", params[:tipo], params[:tipo], params[:tipo], params[:productcollection])  
        else
           usersflags = User.joins(:atendimento).joins(:users_products).select("users.id").where("active = 'S' and islead = 'false' and ((? = 'F' and atendimentos.ispf = 'S') or (? = 'J' and atendimentos.ispj = 'S') or (? = 'C' and atendimentos.ischat = 'S')) and (users_products.product_id = ?)", params[:tipo], params[:tipo], params[:tipo], params[:productcollection])  
        end
        
        leaditem = User.joins("LEFT JOIN leads ON leads.user_id = users.id and leads.leadstatus_id = 1").select("users.*, count(leads.id) as lead_count").where("users.id IN(?)", usersflags).group("users.id").order("lead_count asc").limit(1)
        if leaditem.exists?
          user = leaditem[0].id
          name = leaditem[0].name
          email = leaditem[0].email
          isemail = leaditem[0].isemail
          groupid = leaditem[0].groups_id
        end
        contact = Contact.create(name: params[:nome], email: params[:email], phone: params[:telefone], address: params[:bairro], city: params[:cidade], contacttype: params[:tipo])
        if contact.save
            lead = Lead.create(user_id: user, leadstatus_id: startstatus, contact_id: contact.id, title: params[:titulo], description: params[:descricao], numberproduct: params[:numberproduct])
            if lead.save
              LeadHistory.create(leadstatus_id: startstatus, user_id: user, lead_id: lead.id).save
              LeadProduct.create(product_id: params[:productcollection], lead_id: lead.id).save
              
              #Push
              Pusher.trigger('lead_channel', 'created', {
                message: 'Novo Lead cadastrado para você',
                user: user,
                lead: lead.id
              })
              
              if isemail == 'true'
                LeadMailer.created(email).deliver
              end
              
              #envia o e-mail para o supervisor.
              group = Group.find(groupid) rescue nil
              if !group.nil
                usersuper = User.find(group.ownerid) rescue nil
                if !usersuper.nil
                    LeadMailer.created_super(usersuper.email, name).deliver
                end
              end
              lead
            else
              contact.errors.full_messages
            end
        else
            contact.errors.full_messages
        end
        { :sucess => 'ok', :lead => lead}
        
        #Adiciona o Lead para um consultor disponivel.
      end
      
      desc "Delete a Lead Status."
      params do
        requires :id, type: String, desc: "Lead Status ID."
      end
      delete 'status/:id', authorize: ['delete', 'Lead'] do
        apartment!
        LeadStatus.find(params[:id]).destroy
      end
    
      desc "Return all Lead."
      params do
        requires :page, type: Integer, desc: "Number Page."
        optional :orderby, type: String, desc: "Order by."
        optional :data, type: String, desc: "Filter Data: Init."
        optional :data_end, type: String, desc: "Filter Data: End."
        optional :users_id, type: Integer, desc: "Filter por Users."
      end
      get '/', authorize: ['read', 'Lead'] do
        @user = current_user
        apartment!
        #binding.pry
        
        per_page = 30.0
        
        filter = 'true'
        
        if params[:orderby] == nil or params[:orderby] == ''
          params[:orderby] = "leads.id desc"
        end
        
        if params[:users_id] != nil and params[:users_id] != 0
          filter += " and leads.user_id ="+params[:users_id].to_s
        end
        
        if params[:data] != nil and params[:data] != ''
          filter += " and leads.created_at::timestamp::date between '"+params[:data]+"' and '"+params[:data_end]+"'"
        end
        
        #Retorna todos os leads para Super Admin ou Administrador
        if @user["roles"] == 1 or @user["roles"] == 2
          leadcount = Lead.joins(:user).joins(:contact).joins(:leadstatus).count(filter)
          pages = (leadcount / per_page).ceil
          @lead = Lead.joins("LEFT JOIN public.users ON leads.user_id = users.id").joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY HH:mm') as data, '"+pages.to_s+"' as pages").where(filter).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby])
        #Retorna todos os leads do grupo, para responsável
        elsif Group.where(:users_id => @user["id"]).exists?
          ary = Array.new
          leads_group = Group.all_children(ary, @user["groups_id"])
          leadcount = Lead.joins(:user).joins(:contact).joins(:leadstatus).where("users.groups_id IN (?) and ?", leads_group, filter).count
          pages = (leadcount / per_page).ceil
          @lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY HH:mm') as data, '"+pages.to_s+"' as pages").where("users.groups_id IN (?) and ?", leads_group, filter).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby])
        #Retorna os Leads para usuário
        else
          leadcount = Lead.joins(:user).joins(:contact).joins(:leadstatus).where("leads.user_id = ? and ?",@user["id"], filter).count
          pages = (leadcount / per_page).ceil
          @lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY HH:mm') as data, '"+pages.to_s+"' as pages").where("leads.user_id = ?", @user["id"]).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby])
        end
        #@lead
      end
      
      desc "Return one Lead."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get '', authorize: ['read', 'Lead'] do
          @user = current_user
          apartment!
          @lead = Lead.find(params[:id])
          
          if @lead.user_id == @user['id'] or (@user["roles"] == 1 or @user["roles"] == 2)
            Lead.joins("LEFT JOIN public.users ON leads.user_id = users.id").joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.*, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY') as data, leads.docfile_file_name").where("leads.id = ?", params[:id])
          else
            { :error => 'Sem permissão de acesso', :code => 2002}
          end
        end
      end
      
      desc "Create a Lead."
      params do
        requires :owner, type: String, desc: "User ID Owner."
        requires :status, type: String, desc: "Status Lead"
        requires :contact, type: String, desc: "Contact ID of Lead."
        requires :title, type: String, desc: "Ttile Lead."
        optional :description, type: String, desc: "Description Lead."
      end
      post '', authorize: ['create', 'Lead'] do
        apartment!
        
        lead = Lead.create(user_id: params[:owner], leadstatus_id: params[:status], contact_id: params[:contact], title: params[:title], description: params[:description])
        
        if lead.save
            lead
        else
            lead.errors.full_messages
        end
      end
      
      desc "Import a Lead."
      post 'import', authorize: ['create', 'Lead'] do
        apartment!
        docfile = params[:file]
        
        attachment = {
            :filename => docfile[:filename],
            :type => docfile[:type],
            :headers => docfile[:head],
            :tempfile => docfile[:tempfile]
        }
        
        importfile = ImportFile.create(docfile: ActionDispatch::Http::UploadedFile.new(attachment), status: 'Lead')
        filename = Rails.root.join("public", "importtmp/"+importfile.docfile_file_name)
        
        options = {:col_sep => ";", :row_sep => "\n", :file_encoding => 'ISO-8859-1'}
        ary = Array.new
        SmarterCSV.process(filename, options) do |array|
          if !Lead.where(:code => array.first[:code]).exists?
            ownercheck = User.where('code = ? and code is not  null',array.first[:owner]).first rescue nil
            contactcheck = Contact.where('code = ? and code is not  null',array.first[:contact]).first rescue nil
            if !contactcheck.nil? and !ownercheck.nil?
              lead = Lead.create(user_id: ownercheck.id, contact_id: contactcheck.id, leadstatus_id: array.first[:status], title: array.first[:title], description: array.first[:description], code: array.first[:code])
              if lead.save
                ary << {code: '1', message: 'sucesse', lead: array.first[:code]}
              else
                ary << {code: '12', message: 'error', lead: array.first[:code], error: group.errors.full_messages}
              end
            else
              ary << {code: '13', message: 'error', lead: array.first[:code], error: 'Responsável ou Contato não encontrado.'}
            end
          else
            ownercheck = User.where('code = ? and code is not  null',array.first[:owner]).first rescue nil
            contactcheck = Contact.where('code = ? and code is not  null',array.first[:contact]).first rescue nil
            if !contactcheck.nil? and !ownercheck.nil?
              lead = Lead.where(:code => array.first[:code]).first.update(user_id: ownercheck.id, contact_id: contactcheck.id, leadstatus_id: array.first[:status], title: array.first[:title], description: array.first[:description])
              ary << {code: '1', message: 'sucesse', lead: array.first[:code]}
            else
              ary << {code: '13', message: 'error', lead: array.first[:code], error: 'Responsável ou Contato não encontrado.'}
            end
          end
        end
        ary
      end
      
      desc "Update a Lead."
      params do
        requires :id, type: String, desc: "Bank ID."
        requires :owner, type: String, desc: "User ID Owner."
        requires :status, type: String, desc: "Status Lead"
        requires :contact, type: String, desc: "Contact ID of Lead."
        requires :title, type: String, desc: "Ttile Lead."
        optional :description, type: String, desc: "Description Lead."
      end
      put ':id', authorize: ['create', 'Lead'] do
        apartment!
        Lead.find(params[:id]).update(user_id: params[:owner], leadstatus_id: params[:status], contact_id: params[:contact], title: params[:title], description: params[:description])
      end
      
      desc "Delete a Lead."
      params do
        requires :id, type: String, desc: "Lead ID."
      end
      delete ':id', authorize: ['delete', 'Lead'] do
        apartment!
        Lead.find(params[:id]).destroy
      end
  end
end