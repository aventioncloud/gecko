module V1
  class LeadAPI < Base
      namespace "lead"

      require 'pusher'
      require 'markaby'
      Pusher.url = "https://63230285f168f50e6200:55828354e0f70f99e33f@api.pusherapp.com/apps/183185"

      desc "Create Status Lead."
      params do
        requires :id, type: String, desc: "ID Status."
        requires :name, type: String, desc: "Name Status."
        requires :color, type: String, desc: "Color Status."
      end
      post "status", authorize: ['all', 'Super Admin'] do
        apartment!
        status = LeadStatus.new(
          :id => params[:id],
          :name => params[:name],
          :color => params[:name])
        if status.save
            status
        else
            status.errors.full_messages
        end
      end

      desc "Return all Time."
      get 'time', authorize: ['read', 'Lead'] do
        Time.zone.now
      end

      desc "Return all Lead."
      get 'status', authorize: ['read', 'Lead'] do
        apartment!

        LeadStatus.all
      end

      desc "Audit all Lead."
      params do
        requires :id, type: Integer, desc: "ID do Lead."
      end
      get 'audit/:id', authorize: ['all', 'Super Admin'] do
        apartment!
        if params[:id] != nil and params[:id] != 0
          ary = Array.new
          #ary << {:badgeClass => "", :badgeIconClass => "", :title => "", :content => "" }
          i = 0
          nodo = Lead.find(params[:id])
          versions = nodo.versions
          #versions
          versions.each_with_index do |item, index|
            if item.whodunnit == "job_cad"
              content = content_lead! item, versions, index
              ary << {:badgeClass => "success", :badgeIconClass => "glyphicon-pencil", :title => "Lead Recebido", :content => content}
            elsif item.whodunnit == "job_fila"
              #ary << {:badgeClass => "glyphicon-pencil", :badgeIconClass => "info", :title => "Lead Tranferido", :content => nodo.versions[(i * -1)].previous.contact_id, :itens => item}
              object = item.reify(options = {})
              content = content_lead! item, versions, index
              ary << {:badgeClass => "info", :badgeIconClass => "glyphicon-refresh", :title => "Lead Tranferido", :content => content}
            else
              object = item.reify(options = {})
              content = content_lead! item, versions, index
              if content == "" or content.nil?
                ary << {:badgeClass => "warning", :badgeIconClass => "glyphicon-user", :title => "Lead Alterado Manualmente", :content => item.whodunnit + ", Data:"+item.created_at.strftime("%d/%m/%Y %H:%M")}
              else
                ary << {:badgeClass => "warning", :badgeIconClass => "glyphicon-user", :title => "Lead Alterado Manualmente", :content => content}
              end
            end
          end
          ary.uniq
        else
          data_start = Date.parse(params[:date_sta])
          data_end = Date.parse(params[:date_end])
          #         filter += " and leads.created_at::timestamp::date between '"+params[:data]+"' and '"+params[:data_end]+"'"
          version = PaperTrail::Version
              .where("item_type = 'Lead' and created_at::timestamp::date between ? and ?",data_start,data_end)
              .order('id DESC')
              .limit(10)
          ary = Array.new
          ary << {:badgeClass => "", :badgeIconClass => "", :title => "", :content => "" }
          version.each do |item|
              if item.whodunnit == "job_cad"
                ary << {:badgeClass => "glyphicon-pencil", :badgeIconClass => "info", :title => "Lead Recebido", :content => item.object[:contact_id] }
              elsif item.whodunnit == "job_fila"

              else

              end
          end
          #version
          ary
          #Lead.versions.between(data_start, data_end)
        end
      end

      desc "Audit all Atendimento."
      params do
        optional :id, type: String, desc: "ID do User."
        optional :date_sta, type: String, desc: "Date Start."
        optional :date_end, type: String, desc: "Date End."
      end
      get 'audit_atendimento', authorize: ['all', 'Super Admin'] do
        apartment!
        if params[:id] != nil and params[:id] != 0
          PaperTrail::Version
              .where("item_type = 'Atendimento' and item_id = ?",params[:id])
              .order('id DESC')
              .limit(300)
        else
          data_start = Date.parse(params[:date_sta])
          data_end = Date.parse(params[:date_end])
          #         filter += " and leads.created_at::timestamp::date between '"+params[:data]+"' and '"+params[:data_end]+"'"
          PaperTrail::Version
              .where("whodunnit != 'job_cad' and item_type = 'Atendimento' and created_at::timestamp::date between ? and ?",data_start,data_end)
              .order('id ASC')
              .limit(300)
          #Lead.versions.between(data_start, data_end)
        end
      end

      desc "Compare Version Audit Lead."
      params do
        optional :id, type: Integer, desc: "ID do Lead."
        requires :version_id, type: Integer, desc: "Version ID"
        optional :version2_id, type: Integer, desc: "Version 2 ID"
      end
      get 'compare', authorize: ['all', 'Super Admin'] do
        apartment!
        content_1 = Lead.find(params[:id])
        content_2 = content_1.versions.find(params[:version_id]).reify

        if params[:version2_id] != nil
           content_3 = content_1.versions.find(params[:version2_id]).reify
           changes = Diffy::Diff.new(content_2.to_json, content_3.to_json,
                                       include_plus_and_minus_in_html: true,
                                       include_diff_info: false)
        else
           changes = Diffy::Diff.new(content_2.to_json, content_1.to_json,
                                       include_plus_and_minus_in_html: true,
                                       include_diff_info: false)
        end
        changes.to_s.present? ? changes.to_s(:html).html_safe : 'No Changes'

      end

      desc "Compare Version Audit Atendimento."
      params do
        optional :id, type: Integer, desc: "ID do Lead."
        requires :version_id, type: Integer, desc: "Version ID"
      end
      get 'compare_atendimento', authorize: ['all', 'Super Admin'] do
        apartment!
        content_1 = Atendimento.find(params[:id])
        content_2 = content_1.versions.find(params[:version_id]).reify

        changes = Diffy::Diff.new(content_2.to_json, content_1.to_json,
                                     include_plus_and_minus_in_html: true,
                                     include_diff_info: false)
        changes.to_s.present? ? changes.to_s(:html).html_safe : 'No Changes'
      end

      desc "Roll Back"
      params do
        requires :id, type: Integer, desc: "LEAD ID"
        requires :version_id, type: Integer, desc: "Version ID"
      end
      get 'rollback', authorize: ['read', 'Lead'] do
        apartment!
        @version = PaperTrail::Version.find(params["version_id"])
        if @version.reify
          @version.reify.save!
        end
        @version.reify
      end

      desc "Change Status Lead."
      params do
        requires :id, type: Integer, desc: "ID do Lead."
        requires :status, type: Integer, desc: "ID do Status do Lead."
        optional :comment, type: String, desc: "String do Lead."
        optional :other, type: String, desc: "Other do Lead."
        optional :file_id, type: String, desc: "File do Lead."
      end
      post 'changestatus', authorize: ['read', 'Lead'] do
        @user = current_user rescue nil
        apartment!
        PaperTrail.whodunnit = @user["email"]
        @lead = Lead.joins(:contact).joins(:user).select("leads.*, contacts.email, users.email as user_email").find(params[:id]) rescue nil
        #binding.pry

        if @lead != nil
          #Verfica se o Lead é do usuario que quer alterar
          if @lead.user_id != @user["id"]
            { code: 401, mensage: 'sem permissão'}
            return
          end
          if @comment != nil and !@comment.empty?
            @comment = CGI.unescapeHTML(params[:comment]).html_safe
          elsif params[:other] != nil and !params[:other].empty?
            @comment = CGI.unescapeHTML(params[:other]).html_safe
          end
          LeadHistory.create(leadstatus_id: params[:status], user_id: @lead.user_id, lead_id: params[:id], comment: @comment, lead_file_id: params[:file_id]).save
          Lead.find(params[:id]).update(:leadstatus_id => params[:status])
          filename = nil
          if params[:file_id] != nil and !params[:file_id].empty?
            filename = LeadFile.find(params[:file_id]).docfile_file_name rescue nil
          end
          if @comment != nil and !@comment.empty? and params[:other].empty?
            #LeadMailer.prospect(@lead.email, @lead.user_email, filename, @comment).deliver
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
        @user = current_user rescue nil
        PaperTrail.whodunnit = @user["email"]
        @user = User.find(params[:user_id]) rescue nil
        apartment!
        @lead = Lead.joins(:contact).select("leads.*, contacts.email").find(params[:id]) rescue nil
        #binding.pry
        if @lead != nil and @user != nil
          #Adiciona mais 30 min a fila do lead
          date = Time.zone.now + 30.minutes
          Lead.find(params[:id]).update(:user_id => @user.id, :queue_at => date)
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
        filter = nil
        if params[:status_id] == 3
          filter = [3, 5, 6, 7, 8]
          LeadHistory.where(:lead_id => params[:id]).joins("LEFT JOIN lead_files ON lead_histories.lead_file_id = lead_files.id").joins("LEFT JOIN lead_statuses ON lead_histories.leadstatus_id = lead_statuses.id").select("lead_histories.*, lead_files.id as file_id, lead_files.docfile_file_name, to_char(lead_histories.created_at, 'DD/MM/YYYY HH:mm') as data, lead_statuses.name").where("lead_histories.leadstatus_id in (?)", filter)
        else
          LeadHistory.where(:lead_id => params[:id]).joins("LEFT JOIN lead_files ON lead_histories.lead_file_id = lead_files.id").select("lead_histories.*, lead_files.id as file_id, lead_files.docfile_file_name, to_char(lead_histories.created_at, 'DD/MM/YYYY HH:mm') as data")
        end

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

      desc "List all Atendimento."
      get 'all_atendimento' do
          apartment!
          atendimento = Atendimento.where("ispf = 'S' or ispj = 'S'")
          atendimento
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
        PaperTrail.whodunnit = 'job_cad'
        if params[:numberproduct] != nil and params[:numberproduct] != 0 and params[:numberproduct] >= 20
           usersflags = User.joins(:atendimento).joins(:users_products).select("users.id").where("active = 'S' and islead = 'true' and ((? = 'F' and atendimentos.ispf = 'S') or (? = 'J' and atendimentos.ispj = 'S') or (? = 'C' and atendimentos.ischat = 'S')) and (users_products.product_id = ?)", params[:tipo], params[:tipo], params[:tipo], params[:productcollection])
        else
           usersflags = User.joins(:atendimento).joins(:users_products).select("users.id").where("active = 'S' and (islead = 'false' or islead is null) and ((? = 'F' and atendimentos.ispf = 'S') or (? = 'J' and atendimentos.ispj = 'S') or (? = 'C' and atendimentos.ischat = 'S')) and (users_products.product_id = ?)", params[:tipo], params[:tipo], params[:tipo], params[:productcollection])
        end

        if params[:tipo] == "F"
           leaditem = User.joins("LEFT JOIN atendimentos ON atendimentos.users_id = users.id").select("users.*, atendimentos.leadnumber").where("users.id IN(?)", usersflags).order("leadnumber asc").limit(1)
        else
           leaditem = User.joins("LEFT JOIN atendimentos ON atendimentos.users_id = users.id").select("users.*, atendimentos.leadnumber").where("users.id IN(?)", usersflags).order("leadnumberpj asc").limit(1)
        end

        if leaditem.exists?
          user = leaditem[0].id
          name = leaditem[0].name
          email = leaditem[0].email
          isemail = leaditem[0].isemail
          groupid = leaditem[0].groups_id
        end
        contact = Contact.create(name: CGI.unescapeHTML(params[:nome]), email: params[:email], phone: params[:telefone], address: params[:bairro], city: params[:cidade], typecontact: params[:tipo])
        if contact.save
            _queue_at = Time.zone.now + 15.minutes
            lead = Lead.create(user_id: user, leadstatus_id: startstatus, contact_id: contact.id, title: CGI.unescapeHTML(params[:titulo]), description: CGI.unescapeHTML(params[:descricao]).html_safe, numberproduct: params[:numberproduct], queue_at: _queue_at)
            if lead.save


              if params[:tipo] == "F"
                totallead = Atendimento.where(:users_id => user).first.leadnumber rescue nil
                if !totallead.nil?
                  totallead = totallead + 1
                  atendimento = Atendimento.where(:users_id => user).first.update(:leadnumber => totallead)
                end
              else
                totallead = Atendimento.where(:users_id => user).first.leadnumberpj rescue nil
                if !totallead.nil?
                  totallead = totallead + 1
                  atendimento = Atendimento.where(:users_id => user).first.update(:leadnumberpj => totallead)
                end
              end

              #totallead = Atendimento.where(:users_id => user).first.leadnumber rescue nil
              #if !totallead.nil?
              #  totallead = totallead + 1
              #  atendimento = Atendimento.where(:users_id => user).first.update(:leadnumber => totallead)
              #end
              LeadHistory.create(leadstatus_id: startstatus, user_id: user, lead_id: lead.id).save
              LeadProduct.create(product_id: params[:productcollection], lead_id: lead.id).save


              domain = request.host
              hosts = domain.sub!(".unicooprj.com.br", "")
              account = Account.where(:subdomain => domain).first rescue nil;

              #Push
              Pusher.trigger('lead_channel', 'created', {
                message: 'Novo Lead cadastrado para você',
                user: user,
                lead: lead.id,
                account_id: account.id
              })

              if isemail == 'true'
                LeadMailer.created(email, lead.id).deliver
              end

              #envia o e-mail para o supervisor.
              group = Group.find(groupid) rescue nil
              if !group.nil?
                usersuper = User.find(group.ownerid) rescue nil
                if !usersuper.nil?
                    LeadMailer.created_super(usersuper.email, name, lead.id).deliver
                end
              end

              #Envia e-mail para o dono do grupo Master
              groupdad = Group.where(:dadgroup => nil).first rescue nil
              if !groupdad.nil?
                userdadlast = User.find(groupdad.users_id) rescue nil
                if !userdadlast.nil?
                  if userdadlast.isemail == 'true'
                    LeadMailer.created_super(userdadlast.email, name, lead.id).deliver
                  end
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

      desc "Leads Não Lido com mais de 30 mins."
      get 'pedentes', authorize: ['read', 'Lead'] do
        apartment!
        lead = Lead.joins("INNER JOIN public.users ON leads.user_id = users.id").joins(:contact).select("users.id as usuario_id, users.groups_id, users.isemail, users.email as usermail, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo").where('leads.leadstatus_id = 1 and leads.queue_at < ?', Time.zone.now)
        lead
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
        optional :users_id, type: Integer, desc: "Filter from Users."
        optional :groups_id, type: Integer, desc: "Filter from Group."
        optional :product_id, type: Integer, desc: "Filter from Product."
        optional :status_id, type: String, desc: "Filter from Status."
        optional :type_people, type: String, desc: "F - Fisica or J - Juridica."
        optional :export, type: String, desc: "Export to PDF"
      end
      get '/', authorize: ['read', 'Lead'] do
        @user = current_user
        apartment!

        #binding.pry

        per_page = 100.0

        filter = 'true'

        if params[:orderby] == nil or params[:orderby] == ''
          params[:orderby] = "leads.queue_at desc"
        end

        if params[:users_id] != nil and params[:users_id] != 0
          filter += " and leads.user_id ="+params[:users_id].to_s
        end

        if params[:status_id] != nil and params[:status_id] != ''
          filter += " and leads.leadstatus_id ="+params[:status_id].to_s
        end

        if params[:groups_id] != nil and params[:groups_id] != 0
          filter += " and users.groups_id ="+params[:groups_id].to_s
        end

        if params[:type_people] != nil and params[:type_people] != "0"
          filter += " and contacts.typecontact ='"+params[:type_people].to_s+"'"
        end

        if params[:product_id] != nil and params[:product_id] != 0
          filter += " and lead_products.product_id ="+params[:product_id].to_s
        end

        if params[:data] != nil and params[:data] != ''
          filter += " and leads.created_at::timestamp::date between '"+params[:data]+"' and '"+params[:data_end]+"'"
        end

        #Retorna todos os leads para Super Admin ou Administrador
        if @user["roles"] == 1 or @user["roles"] == 2
          leaditem = Lead.joins("LEFT JOIN public.users ON leads.user_id = users.id").joins(:contact).joins(:leadproduct).joins(:leadstatus).where(filter).distinct
          leadcount = leaditem.count
          pages = (leadcount / per_page).ceil
          lead = Lead.joins("LEFT JOIN public.users ON leads.user_id = users.id").joins(:contact).joins(:leadproduct).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.updated_at, 'DD/MM/YY HH24:MI') as data, '"+pages.to_s+"' as pages, "+leadcount.to_s+" as qtd_row").where(filter).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby]).distinct
        #Retorna todos os leads do grupo, para responsável
        elsif Group.where(:users_id => @user["id"]).exists?
          ary = Array.new
          leads_group = Group.all_children(ary, @user["groups_id"])
          leadcount = Lead.joins(:user).joins(:contact).joins(:leadstatus).where("users.groups_id IN (?)", leads_group).where(filter).count
          pages = (leadcount / per_page).ceil
          lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.updated_at, 'DD/MM/YY HH24:MI') as data, '"+pages.to_s+"' as pages, "+leadcount.to_s+" as qtd_row").where("users.groups_id IN (?)", leads_group).where(filter).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby])
        #Retorna os Leads para usuário
        else
          leadcount = Lead.joins(:user).joins(:contact).joins(:leadstatus).where("leads.user_id = ?",@user["id"]).count
          pages = (leadcount / per_page).ceil
          lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.updated_at, 'DD/MM/YY HH24:MI') as data, '"+pages.to_s+"' as pages, "+leadcount.to_s+" as qtd_row").where("leads.user_id = ?", @user["id"]).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby])
        end
        lead
        #@lead
      end

      desc "Export all Lead."
      params do
        optional :orderby, type: String, desc: "Order by."
        optional :data, type: String, desc: "Filter Data: Init."
        optional :data_end, type: String, desc: "Filter Data: End."
        optional :users_id, type: Integer, desc: "Filter from Users."
        optional :groups_id, type: Integer, desc: "Filter from Group."
        optional :product_id, type: Integer, desc: "Filter from Product."
        optional :status_id, type: String, desc: "Filter from Status."
        optional :type_people, type: String, desc: "F - Fisica or J - Juridica."
      end
      get '/export', authorize: ['read', 'Lead'] do
        @user = current_user
        apartment!

        filename = 'nil'
        api_string = ((('a'..'z').to_a + (0..9).to_a)).shuffle[0,(rand(100).to_i)].join
        filename = api_string+'_export.pdf'

        #binding.pry

        per_page = 500.0

        filter = 'true'

        if params[:orderby] == nil or params[:orderby] == ''
          params[:orderby] = "leads.queue_at desc"
        end

        if params[:users_id] != nil and params[:users_id] != 0
          filter += " and leads.user_id ="+params[:users_id].to_s
        end

        if params[:status_id] != nil and params[:status_id] != ''
          filter += " and leads.leadstatus_id ="+params[:status_id].to_s
        end

        if params[:groups_id] != nil and params[:groups_id] != 0
          filter += " and users.groups_id ="+params[:groups_id].to_s
        end

        if params[:type_people] != nil and params[:type_people] != "0"
          filter += " and contacts.typecontact ='"+params[:type_people].to_s+"'"
        end

        if params[:product_id] != nil and params[:product_id] != 0
          filter += " and lead_products.product_id ="+params[:product_id].to_s
        end

        if params[:data] != nil and params[:data] != ''
          filter += " and leads.created_at::timestamp::date between '"+params[:data]+"' and '"+params[:data_end]+"'"
        end

        #Retorna todos os leads para Super Admin ou Administrador
        if @user["roles"] == 1 or @user["roles"] == 2
          leaditem = Lead.joins("LEFT JOIN public.users ON leads.user_id = users.id").joins(:contact).joins(:leadproduct).joins(:leadstatus).where(filter).distinct
          leadcount = leaditem.count
          pages = (leadcount / per_page).ceil
          lead = Lead.joins("LEFT JOIN public.users ON leads.user_id = users.id").joins(:contact).joins(:leadproduct).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.updated_at + INTERVAL '1 HOURS', 'DD/MM/YY HH24:MI') as data, '"+pages.to_s+"' as pages, "+leadcount.to_s+" as qtd_row, '"+filename+"' as file_key, contacts.*").where(filter).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby]).distinct
          #Retorna todos os leads do grupo, para responsável
        elsif Group.where(:users_id => @user["id"]).exists?
          ary = Array.new
          leads_group = Group.all_children(ary, @user["groups_id"])
          leadcount = Lead.joins(:user).joins(:contact).joins(:leadstatus).where("users.groups_id IN (?)", leads_group).where(filter).count
          pages = (leadcount / per_page).ceil
          lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.updated_at + INTERVAL '1 HOURS', 'DD/MM/YY HH24:MI') as data, '"+pages.to_s+"' as pages, "+leadcount.to_s+" as qtd_row, '"+filename+"' as file_key, contacts.*").where("users.groups_id IN (?)", leads_group).where(filter).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby])
          #Retorna os Leads para usuário
        else
          leadcount = Lead.joins(:user).joins(:contact).joins(:leadstatus).where("leads.user_id = ?",@user["id"]).count
          pages = (leadcount / per_page).ceil
          lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.updated_at + INTERVAL '1 HOURS', 'DD/MM/YY HH24:MI') as data, '"+pages.to_s+"' as pages, "+leadcount.to_s+" as qtd_row, '"+filename+"' as file_key, contacts.*").where("leads.user_id = ?", @user["id"]).paginate(:page => params[:page], :per_page => per_page).order(params[:orderby])
        end

        mab = Markaby::Builder.new
        mab.html do
          head do
            title "Relatório Unicoop"
            meta :name => "pdfkit-page_size", :content => "Letter"
            meta :name => "pdfkit-orientation", :content => "Landscape"
            meta :name => "pdfkit-margin_top", :content => "0.5in"
            meta :name => "pdfkit-margin_right", :content => "0.5in"
            meta :name => "pdfkit-margin_bottom", :content => "0.5in"
            meta :name => "pdfkit-margin_left", :content => "0.5in"
            style :type => "text/css" do
              %[
              table, tr, td, th, tbody, thead, tfoot {
                page-break-inside: avoid !important;
              }
              table, th, td {
                  border: 1px solid black;
                  border-collapse: collapse;
              }
              th, td {
                  padding: 5px;
                  text-align: left;
                  height: 50px !important;
              }
              ]
            end
          end
          body do
            h1 "Relatório Unicoop"
            table do
              tr do
                th "Nome"
                th "Email"
                th "Telefone"
                #th "Celular"
                th "Bairro"
                th "Cidade"
                th "Corretor"
                th "Operadora"
                th "Horario"
              end
              if !lead.nil?
                lead.each do |itemlead|
                  tr do
                    td itemlead.name
                    td itemlead.email
                    td itemlead.phone
                    #td itemlead.number
                    td itemlead.address
                    td itemlead.city
                    td itemlead.usuario
                    td itemlead.title
                    td itemlead.data
                  end
                end
              end
            end
            p "O limite de resultados por pesquisa é de 500 registros."
          end
        end

        kit = PDFKit.new(mab.to_s, :page_size => 'Letter')
        # Save the PDF to a file
        file = kit.to_file(Rails.root.join('public', 'docfile',filename))

        filename
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

          if @lead.user_id == @user['id'] or (@user["roles"] == 1 or @user["roles"] == 2 or @user["roles"] == 3)
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
          dtacreated =  DateTime.strptime(array.first[:dtacreated], "%d/%m/%Y %H:%M")
          if !Lead.where(:code => array.first[:code]).exists?
            ownercheck = User.where('code = ? and code is not  null',array.first[:owner]).first rescue nil
            contactcheck = Contact.where('code = ? and code is not  null',array.first[:contact]).first rescue nil
            if !contactcheck.nil? and !ownercheck.nil?
              lead = Lead.create(user_id: ownercheck.id, contact_id: contactcheck.id, leadstatus_id: array.first[:status], title: array.first[:title], description: array.first[:description], code: array.first[:code], created_at: dtacreated, updated_at: dtacreated)
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
              lead = Lead.where(:code => array.first[:code]).first.update(user_id: ownercheck.id, contact_id: contactcheck.id, leadstatus_id: array.first[:status], title: array.first[:title], description: array.first[:description], created_at: dtacreated, updated_at: dtacreated)
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
        requires :id, type: Integer, desc: "Lead ID."
        requires :description, type: String, desc: "Description Lead."
        requires :numberproduct, type: Integer, desc: "Number to Lead."
      end
      put ':id', authorize: ['create', 'Lead'] do
        @user = current_user rescue nil
        PaperTrail.whodunnit = @user["email"]
        apartment!
        Lead.find(params[:id]).update(description: params[:description], numberproduct: params[:numberproduct])
        #lead = LeadProduct.where("lead_id = ?", params[:id]).first
        #LeadProduct.find(lead.id).update(product_id: params[:product_id])
      end

      desc "Delete a Lead."
      params do
        requires :id, type: String, desc: "Lead ID."
      end
      delete ':id', authorize: ['delete', 'Lead'] do
        @user = current_user rescue nil
        apartment!
        PaperTrail.whodunnit = @user["email"]
        Lead.find(params[:id]).destroy
      end
  end
end
