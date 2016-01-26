module V1
  class GroupAPI < Base
    namespace "group"
    
      desc "Return all group."
      get '/' do
        apartment!
        guard!
        #binding.pry
        
        PlatformGroup.all
      end
      
      desc "Return one group."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get do
          apartment!
          guard!
          PlatformGroup.find(params[:id])
        end
      end
      
      desc "Create a group."
      params do
        requires :name, type: String, desc: "Group name."
        requires :user_id, type: Integer, desc: "User id."
        optional :groupdad, type: Integer, desc: "Group dad id."
      end
      post do
        apartment!
        guard!
        
        group = PlatformGroup.create(users_id: params[:user_id], name: params[:name], groupdad: params[:groupdad])
        
        if group.save
            #Salva o usuário no team.
            team = PlatformTeam.new do |u|
              u.users_id = params[:user_id]
              u.platform_group_id = params[:group_id]
            end
            team.save
            group
        else
            group.errors.full_messages
        end
      end
      
      desc "Update a group."
      params do
        requires :id, type: String, desc: "Group ID."
        requires :name, type: String, desc: "Group name."
        requires :user_id, type: Integer, desc: "User id."
        optional :groupdad, type: String, desc: "Group dad id."
      end
      put ':id' do
        apartment!
        guard!
        PlatformGroup.find(params[:id]).update({
          users_id: params[:user_id],
          name: params[:name],
          groupdad: params[:groupdad],
        })
      end
      
      desc "Delete a group."
      params do
        requires :id, type: String, desc: "Group ID."
      end
      delete ':id' do
        apartment!
        guard!
        PlatformGroup.find(params[:id]).destroy
      end
  end
end