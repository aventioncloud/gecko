module V1
  class BankAPI < Base
    namespace "bank"
    
      desc "Return all Bank."
      get '/', authorize: ['all', 'Super Admin'] do
        apartment!
        guard!
        #binding.pry
        
        Bank.all
      end
      
      desc "Return one Bank."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get '', authorize: ['all', 'Super Admin'] do
          apartment!
          guard!
          Bank.find(params[:id])
        end
      end
      
      desc "Create a Bank."
      params do
        requires :name, type: String, desc: "Bank name."
        requires :numberbank, type: String, desc: "Number bank of Central Bank Brazil"
        requires :imagesmall, type: String, desc: "Url Image bank Small."
        optional :imagelarge, type: String, desc: "Url Image namk Large"
      end
      post do
        apartment!
        guard!
        
        bank = Bank.create(name: params[:name], numberbank: params[:numberbank], imagesmall: params[:imagesmall], imagelarge: params[:imagelarge])
        
        if bank.save
            bank
        else
            bank.errors.full_messages
        end
      end
      
      desc "Update a Bank."
      params do
        requires :id, type: String, desc: "Bank ID."
        requires :name, type: String, desc: "Bank name."
        requires :numberbank, type: String, desc: "Number bank of Central Bank Brazil"
        requires :imagesmall, type: String, desc: "Url Image bank Small."
        optional :imagelarge, type: String, desc: "Url Image namk Large"
      end
      put ':id' do
        apartment!
        guard!
        Bank.find(params[:id]).update({name: params[:name], numberbank: params[:numberbank], imagesmall: params[:imagesmall], imagelarge: params[:imagelarge]})
      end
      
      desc "Delete a Bank."
      params do
        requires :id, type: String, desc: "Bank ID."
      end
      delete ':id' do
        apartment!
        guard!
        Bank.find(params[:id]).destroy
      end
  end
end