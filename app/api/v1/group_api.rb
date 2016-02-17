module V1
  class GroupAPI < Base
    namespace "group"
    authorizes_routes!
    
      desc "Return all group."
      get '/', authorize: ['read', 'Group'] do
        apartment!
        guard!
        @user = current_user
        apartment!
        @role = Role.where(:name => 'Super Admin')
        
        ary = Array.new
        
        if @role[0][:id] != @user["roles"]
          Group.where("active = 'S'").find_each do |item|
              apartment!
              ary << {:id => item[:id],:name => item[:name], :dadgroup => Group.find(item[:dadgroup]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
          end
        else
          Group.all().find_each do |item|
              if item[:dadgroup] != nil
                ary << {:id => item[:id],:name => item[:name], :active => item[:active], :dadgroup => Group.find(item[:dadgroup]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
              else
                ary << {:id => item[:id],:name => item[:name], :active => item[:active], :dadgroup => nil, :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
              end
          end
        end
        ary
      end
      
      desc "Return one group."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get '', authorize: ['read', 'Group'] do
          apartment!
          Group.find(params[:id])
        end
      end
      
      desc "Create a group."
      params do
        requires :name, type: String, desc: "Group name."
        requires :user_id, type: Integer, desc: "User id."
        optional :dadgroup, type: Integer, desc: "Group dad id."
      end
      post '', authorize: ['create', 'Group'] do
        apartment!
        
        group = Group.create(users_id: params[:user_id], name: params[:name], dadgroup: params[:dadgroup])
        group
        
        #if group.save
        #    #Salva o usuário no team.
        #    team = Group.new do |u|
        #      u.users_id = params[:user_id]
        #      u.platform_group_id = params[:group_id]
        #    end
        #    team.save
        #    group
        #else
        #    group.errors.full_messages
        #end
      end
      
      desc "Update a group."
      params do
        requires :id, type: String, desc: "Group ID."
        requires :name, type: String, desc: "Group name."
        requires :user_id, type: Integer, desc: "User id."
        optional :dadgroup, type: String, desc: "Group dad id."
      end
      put ':id', authorize: ['create', 'Group'] do
        apartment!
        Group.find(params[:id]).update({
          users_id: params[:user_id],
          name: params[:name],
          dadgroup: params[:dadgroup],
        })
      end
      
      desc "Delete a group."
      params do
        requires :id, type: String, desc: "Group ID."
      end
      delete ':id', authorize: ['delete', 'Group'] do
        apartment!
        #Group.find(params[:id]).update(active: 'N')
        Group.find(params[:id]).destroy
      end
      
      desc "Active a Group."
      params do
        requires :id, type: String, desc: "User ID."
      end
      post ':id', authorize: ['create', 'Group']  do
        apartment!
        Group.find(params[:id]).update(active: 'S')
      end
  end
end