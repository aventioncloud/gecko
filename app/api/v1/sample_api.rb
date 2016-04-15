module V1
  class SampleAPI < Base
    namespace "job"
    authorize_routes!

      desc "Queue Lead"
      get '/queue' do
        date = Time.zone.now + 30.minutes
        #binding.pry
        leadary = Array.new
        apartment!
        lead = Lead.joins("INNER JOIN public.users ON leads.user_id = users.id").joins(:contact).select("users.id as usuario_id, users.groups_id, users.isemail, users.email as usermail, users.name as usuario, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo").where('leads.leadstatus_id = 1 and leads.queue_at < ?', Time.zone.now)
        lead.find_each do |array|
          leadary << array
          PaperTrail.whodunnit = 'job_fila'
          Lead.find(array[:id]).update(queue_at: date)
          islead = "(islead = 'false' or islead is null)"
          if array[:numberproduct] != nil and array[:numberproduct] != 0 and array[:numberproduct] >= 20
             islead = "islead = 'true'"
          #else
          #   usersflags = User.joins(:atendimento).joins(:users_products).select("users.id").where("active = 'S' and (islead = 'false' or islead is null) and ((? = 'F' and atendimentos.ispf = 'S') or (? = 'J' and atendimentos.ispj = 'S') or (? = 'C' and atendimentos.ischat = 'S')) and (users_products.product_id = ?) and users.id not in (?)", array[:tipo], array[:tipo], array[:tipo], array[:numberproduct], array[:usuario_id])  
          end
          usersflags = User.joins("LEFT JOIN atendimentos ON atendimentos.users_id = users.id").joins(:users_products).where("active = 'S' and "+islead+" and ((? = 'F' and atendimentos.ispf = 'S') or (? = 'J' and atendimentos.ispj = 'S') or (? = 'C' and atendimentos.ischat = 'S')) and (users_products.product_id = ?) and users.id not in (?)", array[:tipo], array[:tipo], array[:tipo], array[:numberproduct], array[:usuario_id]).select("users.id").all
          
          leaditem = User.joins("LEFT JOIN atendimentos ON atendimentos.users_id = users.id").select("users.*, atendimentos.leadnumber").where("users.id IN(?)", usersflags).order("leadnumber asc").limit(1).all
          leadary << leaditem
          
          if !leaditem[0].nil? && !usersflags.nil?
            Lead.find(array[:id]).update(updated_at: Time.zone.now)
            user = leaditem[0].id
            name = leaditem[0].name
            email = leaditem[0].email
            isemail = leaditem[0].isemail
            groupid = leaditem[0].groups_id
          
            lead = Lead.find(array[:id]).update(user_id: user)
            LeadHistory.create(leadstatus_id: 1, user_id: user, lead_id: array[:id]).save
            LeadProduct.create(product_id: array[:productcollection], lead_id: array[:id]).save
            
            account_id = Account.where(:subdomain => 'dev').first rescue nil;
            
            #Push
            #Pusher.trigger('lead_channel', 'created', {
            #  message: 'Novo Lead cadastrado para você',
            #  user: user,
            #  lead: array[:id],
            #  account_id: account_id
            #})
            
            if isemail == 'true'
              LeadMailer.created(email).deliver
            end
            
            if array[:isemail] == 'true'
              LeadMailer.updated(array[:usermail], 'Indicação Perdida no Sistema').deliver
            end
            
            #envia o e-mail para o supervisor.
            apartment!
            group = Group.find(groupid)
            #binding.pry
            if !group.nil?
              usersuper = User.find(group.users_id) rescue nil
              if !usersuper.nil?
                if usersuper.isemail == 'true'
                  LeadMailer.created_super(usersuper.email, name).deliver
                end
              end
            end
            
            #envia o e-mail para perdida o supervisor.
            grouplast = Group.find(array[:groups_id]) rescue nil
            if !grouplast.nil?
              usersuperlast = User.find(group.users_id) rescue nil
              if !usersuperlast.nil?
                if usersuperlast.isemail == 'true'
                  LeadMailer.updated_super(usersuper.email, name, array[:name], 'Indicação Perdida no Sistema').deliver
                end
              end
            end
          end
          
          break
        end
        { :sucess => 'ok', :lead => leadary}
      end
  end
end
