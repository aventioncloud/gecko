module V1
  class ContactAPI < Base
    namespace "contact"
    
      desc "Return all Contact."
      get '/', authorize: ['read', 'Contact'] do
        apartment!
        #binding.pry
        
        Contact.all
      end
      
      desc "Return one Contact."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get '', authorize: ['read', 'Contact'] do
          apartment!
          Contact.find(params[:id])
        end
      end
      
      desc "Create a Contact."
      params do
        requires :name, type: String, desc: "Contact Name."
        requires :email, type: String, desc: "Contact E-mail."
        optional :phone, type: String, desc: "Contact Phone."
        optional :address, type: String, desc: "Contact Address."
        optional :number, type: String, desc: "Contact number."
        optional :cpfcnpj, type: String, desc: "Contact CPF/CNPJ."
        optional :city, type: String, desc: "Contact City."
        optional :zipcode, type: String, desc: "Contact ZipCode."
      end
      post '', authorize: ['create', 'Contact'] do
        apartment!
        
        contact = Contact.create(name: params[:name], email: params[:email], phone: params[:phone], address: params[:address], number: params[:number], cpfcnpj: params[:cpfcnpj], city: params[:city], zipcode: params[:zipcode])
        
        if contact.save
            contact
        else
            contact.errors.full_messages
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