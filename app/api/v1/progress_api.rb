module V1
  class ProgressAPI < Base
    namespace "progress"
    
      desc "Return all Progress."
      params do
        requires :schedule, type: Integer
      end
      get '/' do
        guard!
        #binding.pry
        
        GogoparkProgress.where(gogopark_spaceschedule_id: schedule)
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
      
      desc "Add reserve."
      params do
        requires :schedule, type: Integer, desc: "Schedule Id."
        requires :provide_start, type: DateTime, desc: "Date Time Provided Start."
        requires :provide_end, type: DateTime, desc: "Date Time Provided End."
        optional :user, type: Integer, desc: "Users Id."
      end
      post "reserve" do
        guard!
        
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