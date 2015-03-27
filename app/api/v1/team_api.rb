module V1
  class TeamAPI < Base
    namespace "team"
    
      desc "Return all team."
      get '/' do
        guard!
        #binding.pry
        
        PlatformTeam.all
      end
      
      desc "Create permission team."
      params do
        requires :user_id, type: Integer, desc: "User id."
        requires :group_id, type: Integer, desc: "Group id."
      end
      post do
        guard!
        team = PlatformTeam.new do |u|
          u.users_id = params[:user_id]
          u.platform_group_id = params[:group_id]
        end
        if team.save
            team
        else
            team.errors.full_messages
        end
      end
      
      desc "Update permission team."
      params do
        requires :id, type: String, desc: "Team ID."
        requires :user_id, type: Integer, desc: "User id."
        requires :group_id, type: Integer, desc: "Group id."
      end
      put ':id' do
        guard!
        PlatformTeam.find(params[:id]).update({
          users_id: params[:user_id],
          platform_group_id: params[:group_id]
        })
      end
      
      desc "Delete permission team for group."
      params do
        requires :group_id, type: Integer, desc: "Group ID."
      end
      delete do
        guard!
        PlatformTeam.destroy_all(:platform_group_id => id)
      end
  end
end