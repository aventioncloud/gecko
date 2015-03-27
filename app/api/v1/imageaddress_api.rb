module V1
  class ImageAddressAPI < Base
    namespace "imageaddress"
    
      desc "Return all Image Address."
      params do
        requires :address, type: Integer
      end
      get '/' do
        guard!
        #binding.pry
        
        GogoparkSpaceimages.where(address_id: address)
      end
      
      desc "Return one Image Address."
      params do
        requires :id, type: Integer
      end
      route_param :id do
      get do
          guard!
          GogoparkSpaceimages.find(params[:id])
        end
      end
      
      desc "Create a Image Address."
      params do
        requires :address, type: Integer, desc: "Address Id."
        requires :filename, type: String, desc: "Filename Id."
        optional :description, type: String, desc: "Description."
      end
      post do
        guard!
        space = GogoparkSpaceimages.new do |u|
          u.gogopark_address_id = params[:address]
          u.filename = params[:filename]
          u.description = params[:description]
        end
        if space.save
            space
        else
            space.errors.full_messages
        end
      end
      
      desc "Update a Image Address."
      params do
        requires :id, type: String, desc: "Team ID."
        requires :address, type: Integer, desc: "Address Id."
        requires :filename, type: String, desc: "Filename Id."
        optional :description, type: String, desc: "Description."
      end
      put ':id' do
        guard!
        GogoparkSpaceimages.find(params[:id]).update({
          gogopark_address_id: params[:address],
          filename: params[:filename],
          description: params[:description]
        })
      end
      
      desc "Delete a Image Address."
      params do
        requires :address, type: Integer, desc: "Address ID."
      end
      delete do
        guard!
        GogoparkSpaceimages.destroy_all(:gogopark_address_id => address)
      end
  end
end