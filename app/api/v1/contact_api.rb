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
      
      desc "Import a group."
      post 'import', authorize: ['create', 'Contact'] do
        apartment!
        docfile = params[:file]
        
        attachment = {
            :filename => docfile[:filename],
            :type => docfile[:type],
            :headers => docfile[:head],
            :tempfile => docfile[:tempfile]
        }
        
        importfile = ImportFile.create(docfile: ActionDispatch::Http::UploadedFile.new(attachment), status: 'Contact')
        filename = Rails.root.join("public", "importtmp/"+importfile.docfile_file_name)
        
        options = {:col_sep => ";", :row_sep => "\n", :file_encoding => 'ISO-8859-1'}
        ary = Array.new
        SmarterCSV.process(filename, options) do |array|
          if !Contact.where(:code => array.first[:code]).exists?
            contact = Contact.create(name: array.first[:name], email: array.first[:email], phone: array.first[:phone], address: array.first[:address], city: array.first[:city], code: array.first[:code], typecontact: array.first[:contacttype])
            if contact.save
              ary << {code: '1', message: 'sucesse', contact: array.first[:name]}
            else
              ary << {code: '12', message: 'error', contact: array.first[:name], error: group.errors.full_messages}
            end
          else
            contact = Contact.where(:code => array.first[:code]).first.update(name: array.first[:name], email: array.first[:email], phone: array.first[:phone], address: array.first[:address], city: array.first[:city], typecontact: array.first[:contacttype])
            ary << {code: '1', message: 'sucesse', contact: array.first[:name]}
          end
        end
        ary
      end
      
      desc "Create a Contact."
      params do
        requires :contacttype, type: String, desc: "Contact Type(F, J)."
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
        
        contact = Contact.create(name: params[:name], email: params[:email], phone: params[:phone], address: params[:address], number: params[:number], cpfcnpj: params[:cpfcnpj], city: params[:city], zipcode: params[:zipcode], contacttype: params[:contacttype])
        
        if contact.save
            contact
        else
            contact.errors.full_messages
        end
      end
      
      desc "Update a Contact."
      params do
        requires :id, type: String, desc: "Contact ID."
        requires :contacttype, type: String, desc: "Contact Type(F, J)."
        requires :name, type: String, desc: "Contact Name."
        requires :email, type: String, desc: "Contact E-mail."
        optional :phone, type: String, desc: "Contact Phone."
        optional :address, type: String, desc: "Contact Address."
        optional :number, type: String, desc: "Contact number."
        optional :cpfcnpj, type: String, desc: "Contact CPF/CNPJ."
        optional :city, type: String, desc: "Contact City."
        optional :zipcode, type: String, desc: "Contact ZipCode."
      end
      put ':id' do
        apartment!
        Contact.find(params[:id]).update(name: params[:name], email: params[:email], phone: params[:phone], address: params[:address], number: params[:number], cpfcnpj: params[:cpfcnpj], city: params[:city], zipcode: params[:zipcode], contacttype: params[:contacttype])
      end
      
      desc "Delete a Contact."
      params do
        requires :id, type: String, desc: "Contact ID."
      end
      delete ':id' do
        apartment!
        Contact.find(params[:id]).destroy
      end
  end
end