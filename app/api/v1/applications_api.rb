module V1
  class ApplicationsAPI < Base
      require_relative '../../lib/api/validations/email_value'
      require_relative '../../lib/api/validations/subdomain_value'
    
      namespace "application"
      
      desc "Return all application."
      get '/', authorize: ['all', 'Super Admin'] do
        #guard!

        Account.all
      end
      
      desc "Create a Application."
      params do
        requires :name, type: String, desc: "Name User."
        requires :email, email: true, type: String, desc: "E-mail User."
        requires :password, type: String, desc: "Password User."
        requires :subdomain, subdomain: true, type: String, desc: "Subdomain name."
      end
      post '', authorize: ['all', 'Super Admin'] do
        #guard!
        
        Apartment::Tenant.create(params[:subdomain])
        Apartment::Tenant.switch!(params[:subdomain])
        
        user = User.new(
              :email                 => params[:email],
              :password              => params[:password],
              :password_confirmation => params[:password],
              :name =>params[:name],
              :roles => 1#Administrator
          )
          user.save!
          
        account = Account.new(
                :owner_id                 => user.id,
                :subdomain              => params[:subdomain],
        )
        account.save
        
        User.find(user.id).update({ accounts_id:  account.id})
        
        account.save!
        
      end
      
      
      desc "Delete a application."
      params do
        requires :subdomain, type: String, desc: "Subdomain name."
      end
      delete '', authorize: ['all', 'Super Admin'] do
        guard!
        account = Account.where(:subdomain => params[:subdomain])
        Account.destroy_all(:subdomain => params[:subdomain])
        #User.destroy_all(:accounts_id => account.firts.id)
        Apartment::Tenant.drop(params[:subdomain])
      end
  end
end