module V1
  require 'smarter_csv'
  class GroupAPI < Base
    namespace "group"
    authorizes_routes!
    
      desc "Return all group."
      get '/', authorize: ['read', 'Group'] do
        @user = current_user
        apartment!
        ary = Array.new
        if 1 != @user["roles"]
          Group.where("active = 'S'").find_each do |item|
              ary << {:id => item[:id],:name => item[:name], :owner => User.find(item[:users_id]), :dadgroup => Group.find(item[:dadgroup]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
          end
        else
          Group.all().find_each do |item|
              @useritem = User.find(item[:users_id]) rescue nil
              if item[:dadgroup] != nil
                ary << {:id => item[:id],:name => item[:name], :active => item[:active], :owner => @useritem, :dadgroup => Group.find(item[:dadgroup]), :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
              else
                ary << {:id => item[:id],:name => item[:name], :active => item[:active], :owner => @useritem, :dadgroup => nil, :created_at => item[:created_at].strftime("%b, %m %Y - %H:%M") }
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
      
      desc "Import a group."
      post 'import', authorize: ['create', 'Group'] do
        apartment!
        docfile = params[:file]
        
        attachment = {
            :filename => docfile[:filename],
            :type => docfile[:type],
            :headers => docfile[:head],
            :tempfile => docfile[:tempfile]
        }
        
        importfile = ImportFile.create(docfile: ActionDispatch::Http::UploadedFile.new(attachment), status: 'Group')
        filename = Rails.root.join("public", "importtmp/"+importfile.docfile_file_name)
        
        options = {:col_sep => ";", :row_sep => "\n"}
        ary = Array.new
        teste = ""
        SmarterCSV.process(filename, options) do |array|
          groupcheck = Group.where('code = ? and code is not null',array.first[:groupid]).first rescue nil
          groupdad = nil
          if !groupcheck.nil?
            groupdad = groupcheck.id
          end
          ownercheck = User.where('code = ? and code is not  null',array.first[:ownerid]).first rescue nil
          owner = nil
          if !ownercheck.nil?
            owner = ownercheck.id
          end
          if !Group.where(:code => array.first[:code]).exists?
            group = Group.create(users_id: owner, name: array.first[:name], dadgroup: groupdad, code: array.first[:code])
            if group.save
              ary << {code: '1', message: 'sucesse', group: array.first[:name]}
            else
              ary << {code: '12', message: 'error', group: array.first[:name], error: group.errors.full_messages}
            end
          else
            group = Group.where(:code => array.first[:code]).first.update(users_id: owner, name: array.first[:name], dadgroup: groupdad, code: array.first[:code])
            ary << {code: '1', message: 'sucesse', group: array.first[:name]}
          end
        end
        ary
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