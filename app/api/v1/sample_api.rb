module V1
  class SampleAPI < Base
    namespace "job"
    #authorize_routes!

      desc "Queue Lead"
      get '/queue' do
        date = Time.zone.now + 15.minutes
        #binding.pry
        leadary = Array.new
        apartment!
        lead = Lead.joins("INNER JOIN public.users ON leads.user_id = users.id").joins(:contact).select("users.id as usuario_id, users.groups_id, users.isemail, users.email as usermail, users.name as usuario, users.totalperda, leads.*, contacts.id as contact_id, contacts.name, contacts.typecontact as tipo").where('leads.leadstatus_id = 1 and leads.queue_at < ?', Time.zone.now)
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
          usersflags = User.joins("LEFT JOIN atendimentos ON atendimentos.users_id = users.id").joins(:users_products).where("active = 'S' and "+islead+" and ((? = 'F' and atendimentos.ispf = 'S') or (? = 'J' and atendimentos.ispj = 'S') or (? = 'C' and atendimentos.ischat = 'S')) and users.id not in (?)", array[:tipo], array[:tipo], array[:tipo], array[:usuario_id]).select("users.id").all

          if array[:tipo] == "F"
            leaditem = User.joins("LEFT JOIN atendimentos ON atendimentos.users_id = users.id").select("users.*, atendimentos.leadnumber").where("users.id IN(?)", usersflags).order("leadnumber asc").limit(1).all
            leadary << leaditem
          else
            leaditem = User.joins("LEFT JOIN atendimentos ON atendimentos.users_id = users.id").select("users.*, atendimentos.leadnumber").where("users.id IN(?)", usersflags).order("leadnumberpj asc").limit(1).all
            leadary << leaditem
          end

          if !leaditem[0].nil? && !usersflags.nil?
            Lead.find(array[:id]).update(updated_at: Time.zone.now)
            user = leaditem[0].id
            name = leaditem[0].name
            email = leaditem[0].email
            isemail = leaditem[0].isemail
            groupid = leaditem[0].groups_id

            userperda = User.find(array[:user_id])
            totalperda = userperda.totalperda + 1 rescue 1
            User.find(array[:user_id]).update(totalperda: totalperda)

            lead = Lead.find(array[:id]).update(user_id: user)

            if array[:tipo] == "F"
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
              LeadMailer.created(email, array[:id]).deliver
            end

            if array[:isemail] == 'true'
              LeadMailer.updated(array[:usermail], 'Indicação Perdida no Sistema', array[:id]).deliver
            end

            #envia o e-mail para o supervisor.
            apartment!
            group = Group.find(groupid)
            #binding.pry
            if !group.nil?
              usersuper = User.find(group.users_id) rescue nil
              if !usersuper.nil?
                if usersuper.isemail == 'true'
                  LeadMailer.created_super(usersuper.email, name, array[:id]).deliver
                end
              end
            end

            #envia o e-mail para perdida o supervisor.
            grouplast = Group.find(array[:groups_id]) rescue nil
            if !grouplast.nil?
              usersuperlast = User.find(group.users_id) rescue nil
              if !usersuperlast.nil?
                if usersuperlast.isemail == 'true'
                  LeadMailer.updated_super(usersuper.email, name, array[:name], 'Indicação Perdida no Sistema', array[:id]).deliver
                end
              end
            end

            #Envia e-mail para o dono do grupo Master
            groupdad = Group.where(:dadgroup => nil).first rescue nil
            if !groupdad.nil?
              userdadlast = User.find(groupdad.users_id) rescue nil
              if !userdadlast.nil?
                if userdadlast.isemail == 'true'
                  LeadMailer.updated_super(userdadlast.email, name, array[:name], 'Indicação Perdida no Sistema', array[:id]).deliver
                end
              end
            end
          end

          break
        end
        { :sucess => 'ok', :lead => leadary}
      end

      desc "Import Century Link"
      get '/import' do
        require 'savon'
        require 'nori'
        #binding.pry
        # create a client for the service
        client = Savon.client(wsdl: 'http://consulta.confirmeonline.com.br/Integracao/Consulta?wsdl')

        #client.operations
        # => [:find_user, :list_users]

        # call the 'findUser' operation
        response = client.call(:completo_whatsapp, message: { usuario: 'INTUNICO', senha: '7xnus2BX', sigla: 'ATURJ', cpfcnpj: '', nome: '', telefone: '31991074216' })

        
        # => { find_user_response: { id: 42, name: 'Hoff' } }
        parser = Nori.new
        my_hash = parser.parse(response.body[:completo_whatsapp_response][:return])
        my_hash
      end
  end
end
