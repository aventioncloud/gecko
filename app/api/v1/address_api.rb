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
          GogoparkAddress.joins(:cidade).find(params[:id]).select("gogopark_addresses.*, cidades.nome as cidade")
        end
      end
      
      desc "Create a address."
      params do
        requires :size, type: String, desc: "Size."  
        requires :address, type: String, desc: "Address." 
        requires :numberhome, type: Integer, desc: "Numberhome."
        optional :complement, type: String, desc: "Complement." 
        requires :neighborhood, type: String, desc: "Neighborhood." 
        requires :postcode, type: String, desc: "Postcode." 
        requires :city, type: Integer, desc: "City Id."
        requires :latitude, type: Float, desc: "Term." 
        requires :longitude, type: Float, desc: "Term." 
        requires :space, type: Integer, desc: "Space Id."
        requires :amount, type: Integer, desc: "Amount."
      end
      post do
        guard!
        GogoparkAddress.create({
          size: params[:size],
          address: params[:address],
          numberhome: params[:numberhome],
          complement: params[:complement],
          neighborhood: params[:neighborhood],
          postcode: params[:postcode],
          cidade_id: params[:city],
          latitude: params[:latitude],
          longitude: params[:longitude],
          gogopark_space_id: params[:space],
          amount: params[:amount],
          active: true
        })
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
        requires :latitude, type: Float, desc: "Term." 
        requires :longitude, type: Float, desc: "Term." 
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
          cidade_id: params[:city],
          latitude: params[:latitude],
          longitude: params[:longitude],
          gogopark_space_id: params[:space],
          amount: params[:amount]
        })
      end
      
      desc "Delete a Address."
      params do
        requires :group_id, type: Integer, desc: "Address ID."
      end
      delete ':id' do
        guard!
        GogoparkAddress.find(params[:id]).update({ active: false });
      end
  end
end