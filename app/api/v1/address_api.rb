module V1
  class AddressAPI < Base
    namespace "address"
    
      desc "Return all address."
      get '/' do
        guard!
        #binding.pry
        
        GogoparkAddress.all
      end
      
      desc "Return one address."
      params do
        requires :id, type: Integer
      end
      route_param :id do
      get do
          guard!
          GogoparkAddress.find(params[:id])
        end
      end
      
      desc "Create a address."
      params do
        requires :size, type: String, desc: "Size."  
        requires :address, type: String, desc: "Address." 
        requires :numberhome, type: Integer, desc: "Numberhome."
        requires :complement, type: String, desc: "Complement." 
        requires :neighborhood, type: String, desc: "Neighborhood." 
        requires :postcode, type: String, desc: "Postcode." 
        requires :city, type: Integer, desc: "City Id."
        requires :latitude, type: Decimal, desc: "Term." 
        requires :longitude, type: Decimal, desc: "Term." 
        requires :space, type: Integer, desc: "Space Id."
        requires :amount, type: Integer, desc: "Amount."
      end
      post do
        guard!
        address = GogoparkAddress.new do |u|
          u.size = params[:size]
          u.address = params[:address]
          u.numberhome = params[:numberhome]
          u.complement = params[:complement]
          u.neighborhood = params[:neighborhood]
          u.postcode = params[:postcode]
          u.city = params[:city]
          u.latitude = params[:latitude]
          u.longitude = params[:longitude]
          u.space = params[:space]
          u.amount = params[:amount]
        end
        if address.save
            address
        else
            address.errors.full_messages
        end
      end
      
      desc "Update a Address."
      params do
        requires :id, type: String, desc: "Address ID."
        requires :size, type: String, desc: "Size."  
        requires :address, type: String, desc: "Address." 
        requires :numberhome, type: Integer, desc: "Numberhome."
        requires :complement, type: String, desc: "Complement." 
        requires :neighborhood, type: String, desc: "Neighborhood." 
        requires :postcode, type: String, desc: "Postcode." 
        requires :city, type: Integer, desc: "City Id."
        requires :latitude, type: Decimal, desc: "Term." 
        requires :longitude, type: Decimal, desc: "Term." 
        requires :space, type: Integer, desc: "Space Id."
        requires :amount, type: Integer, desc: "Amount."
      end
      put ':id' do
        guard!
        GogoparkAddress.find(params[:id]).update({
          size: params[:size],
          address: params[:address],
          numberhome: params[:numberhome],
          complement: params[:complement],
          neighborhood: params[:neighborhood],
          postcode: params[:postcode],
          city: params[:city],
          latitude: params[:latitude],
          longitude: params[:longitude],
          space: params[:space],
          amount: params[:amount]
        })
      end
      
      desc "Delete a Address."
      params do
        requires :group_id, type: Integer, desc: "Address ID."
      end
      delete ':id' do
        guard!
        GogoparkAddress.find(params[:id]).destroy
      end
  end
end