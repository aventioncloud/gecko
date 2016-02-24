module V1
  class LeadAPI < Base
      namespace "lead"
    
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
        optional :orderby, type: String, desc: "Order by."
        optional :data, type: String, desc: "Filter Data."
        optional :users_id, type: Integer, desc: "Filter por Users."
      end
      get '/', authorize: ['read', 'Lead'] do
        @user = current_user
        apartment!
        
        filter = "1 = 1"
        
        if params[:orderby] == nil or params[:orderby] == ''
          params[:orderby] = "leads.id desc"
        end
        
        if params[:users_id] != nil and params[:users_id] != 0
          filter += " and leads.user_id ="+params[:users_id].to_s
        end
        
        if params[:data] != nil and params[:data] != ''
          filter += " and leads.created_at::timestamp::date = TO_DATE('"+params[:data]+"', 'YYYY-MM-DD')"
        end
        
        #Retorna todos os leads para Super Admin ou Administrador
        if @user["roles"] == 1 or @user["roles"] == 2
          @lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY') as data").where(filter).order(params[:orderby])
        #Retorna todos os leads do grupo, para responsável
        elsif Group.where(:users_id => @user["id"]).exists?
          ary = Array.new
          leads_group = Group.all_children(ary, 1)
          @lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY') as data").where("users.groups_id IN (?) and ?", leads_group, filter) 
        #Retorna os Leads para usuário
        else 
          @lead = Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY') as data").where("leads.user_id = ? and ?", @user["id"], filter)
        end
        @lead
        
       
      end
      
      desc "Return one Lead."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get '', authorize: ['read', 'Lead'] do
          apartment!
          Lead.joins(:user).joins(:contact).joins(:leadstatus).select("users.groups_id, users.name as usuario, leads.*, contacts.*, lead_statuses.id as status_id, lead_statuses.name as status, to_char(leads.created_at, 'DD/MM/YYYY') as data").where("leads.id = ?", params[:id])
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
      
      desc "Update a Lead."
      params do
        requires :id, type: String, desc: "Bank ID."
        requires :name, type: String, desc: "Bank name."
        requires :numberbank, type: String, desc: "Number bank of Central Bank Brazil"
        requires :imagesmall, type: String, desc: "Url Image bank Small."
        optional :imagelarge, type: String, desc: "Url Image namk Large"
      end
      put ':id', authorize: ['create', 'Lead'] do
        apartment!
        Bank.find(params[:id]).update({name: params[:name], numberbank: params[:numberbank], imagesmall: params[:imagesmall], imagelarge: params[:imagelarge]})
      end
      
      desc "Delete a Lead."
      params do
        requires :id, type: String, desc: "Bank ID."
      end
      delete ':id', authorize: ['delete', 'Lead'] do
        apartment!
        Bank.find(params[:id]).destroy
      end
  end
end