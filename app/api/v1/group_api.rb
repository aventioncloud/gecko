module V1
  class GroupAPI < Base
    namespace "group"
    
      desc "Return all group."
      get '/' do
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
        guard!
        group = PlatformGroup.new do |u|
          u.users_id = params[:user_id]
          u.name = params[:name]
          u.groupdad = params[:groupdad]
        end
        if group.save
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
        guard!
        PlatformGroup.find(params[:id]).destroy
      end
  end
end