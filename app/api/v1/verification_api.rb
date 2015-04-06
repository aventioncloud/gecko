module V1
  class VerificationAPI < Base
    namespace "verification"
    
      desc "Return all Verification Space."
      params do
        requires :address, type: Integer
      end
      get '/' do
        guard!
        #binding.pry
        
        GogoparkSpaceverifications.where(gogopark_address_id: params[:address])
      end
      
      desc "Return one Verification Space."
      params do
        requires :id, type: Integer
      end
      route_param :id do
      get do
          guard!
          GogoparkSpaceverifications.find(params[:id])
        end
      end
      
      desc "Create a Verification Space."
      params do
        requires :address, type: Integer, desc: "Address Id."
        requires :spaceverications, type: Boolean, desc: "Space verified?"
        requires :spaceverified, type: Boolean, desc: "Space verified?"
        optional :description, type: String, desc: "Description."
      end
      post do
        guard!
        space = GogoparkSpaceverifications.new do |u|
          u.users_id = current_user["id"]
          u.gogopark_address_id = params[:address]
          u.spaceverications = params[:spaceverications]
          u.spaceverified = params[:spaceverified]
          u.description = params[:description]
        end
        if space.save
            space
        else
            space.errors.full_messages
        end
      end
      
      desc "Update a Verification Space."
      params do
        requires :id, type: String, desc: "Team ID."
        requires :spaceverications, type: Boolean, desc: "Space verified?"
        requires :spaceverified, type: Boolean, desc: "Space verified?"
        optional :description, type: String, desc: "Description."
      end
      put ':id' do
        guard!
        GogoparkSpaceverifications.find(params[:id]).update({
          spaceverications: params[:spaceverications],
          spaceverified: params[:spaceverified],
          description: params[:description]
        })
      end
      
      desc "Delete a Verification Address."
      params do
        requires :address, type: Integer, desc: "Address ID."
      end
      delete do
        guard!
        GogoparkSpaceverifications.destroy_all(:gogopark_address_id => params[:address])
      end
  end
end