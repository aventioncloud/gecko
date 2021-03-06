module V1
  class RoleAPI < Base
    require_relative '../../lib/api/validations/deletrolevalid_value'
    namespace "role"
    authorizes_routes!
    
      #Permission
      desc "All permissions in roles."
      params do
        requires :role, type: String, desc: "Role ID."
      end
      get "permission", authorize: ['all', 'Super Admin'] do
        apartment!
        Role.joins(:permissions).select("permissions.*").where("roles.id = ?", params[:role])
      end
      
      desc "List my permissions."
      get "me" do
        guard!
        role_id = current_user["roles"]
        apartment!
        Role.joins(:permissions).select("permissions.id, permissions.subject_class, permissions.action").where("roles.id = ?", role_id)
      end
      
      desc "Create permission."
      params do
        requires :name, type: String, desc: "Name Permission."
        requires :model, type: String, desc: "Model Permission."
        requires :cancan_action, type: String, desc: "Cancan Permission."
      end
      post "permission", authorize: ['all', 'Super Admin'] do
        apartment!
        permission = Permission.new
        permission.name = params[:name]
        permission.subject_class =  params[:model]
        permission.action = params[:cancan_action]
        if permission.save
            permission.roles << Role.where(:name => 'Super Admin')
        end
        permission
      end
      
      desc "Associete Permission Role."
      params do
        requires :role, type: String, desc: "Role ID."
        requires :permission, type: String, desc: "Permission ID."
      end
      post "permissionrole", authorize: ['all', 'Super Admin'] do
        apartment!
        permission = Permission.find(params[:permission])
        if !permission.nil?
            permission.roles << Role.find(params[:role])
        end
        permission
      end
    
      desc "Return all Roles."
      get '/' do
        @user = current_user
        apartment!
        @role = Role.where(:name => 'Super Admin')
        if @role[0][:id] != @user["roles"]
           Role.where("roles.id != ?", @role[0][:id])
        else
           Role.all
        end
      end
      
      desc "Return one Role."
      params do
        requires :id, type: Integer
      end
      route_param :id do
      get '' do
          apartment!
          @role = Role.find(params[:id]) rescue nil
        end
      end
      
      desc "Create a Role."
      params do
        requires :name, type: String, desc: "Role name."
      end
      post '', authorize: ['all', 'Super Admin'] do
        apartment!
        
        item = Role.create(name: params[:name])
        
        if item.save
            item
        else
            item.errors.full_messages
        end
      end
      
      desc "Update a Role."
      params do
        requires :id, type: Integer, desc: "Role ID."
        requires :name, type: String, desc: "Role name."
      end
      put ':id', authorize: ['all', 'Super Admin'] do
        apartment!
        Role.find(params[:id]).update({name: params[:name]})
      end
      
      desc "Delete a Role."
      params do
        requires :id, deletrolevalid: true, type: String, desc: "Role ID."
      end
      delete ':id', authorize: ['all', 'Super Admin'] do
        apartment!
        Role.find(params[:id]).destroy
      end
  end
end