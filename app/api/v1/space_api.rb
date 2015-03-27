module V1
  class SpaceAPI < Base
    namespace "space"
    
      desc "Return all space."
      get '/' do
        guard!
        #binding.pry
        
        GogoparkSpace.all
      end
      
      desc "Return one space."
      params do
        requires :id, type: Integer
      end
      route_param :id do
      get do
          guard!
          GogoparkSpace.find(params[:id])
        end
      end
      
      desc "Create a space."
      params do
        requires :group, type: Integer, desc: "Group Id."
        requires :term, type: String, desc: "Term."
        optional :description, type: String, desc: "Description."
      end
      post do
        guard!
        space = GogoparkSpace.new do |u|
          u.users_id = current_user["id"]
          u.platform_group_id = params[:group]
          u.term = params[:term]
          u.description = params[:description]
        end
        if space.save
            space
        else
            space.errors.full_messages
        end
      end
      
      desc "Update a Space."
      params do
        requires :id, type: String, desc: "Team ID."
        requires :group, type: Integer, desc: "Group Id."
        requires :term, type: String, desc: "Term."
        optional :description, type: String, desc: "Description."
      end
      put ':id' do
        guard!
        PlatformTeam.find(params[:id]).update({
          users_id: current_user["id"],
          platform_group_id: params[:group_id],
          term: params[:term],
          description: params[:description]
        })
      end
      
      desc "Delete a space."
      params do
        requires :group_id, type: Integer, desc: "Group ID."
      end
      delete ':id' do
        guard!
        PlatformTeam.find(params[:id]).destroy
      end
  end
end