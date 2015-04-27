module V1
  class SchedulesAPI < Base
    namespace "schedules"
    
      desc "Return all Schedules Address."
      params do
        requires :address, type: Integer
      end
      get '/' do
        guard!
        #binding.pry
        
        GogoparkSpaceschedule.where(gogopark_address_id: params[:address])
      end
      
      desc "Return one Schedules Address."
      params do
        requires :id, type: Integer
      end
      route_param :id do
      get do
          guard!
          GogoparkSpaceschedule.find(params[:id])
        end
      end
      
      desc "Create a Schedules Address."
      params do
        requires :address, type: Integer, desc: "Address Id."
        requires :maxreserve, type: Integer, desc: "Numb Max Reserve."
        requires :name, type: String, desc: "Name Schedules."
        requires :description, type: String, desc: "Description Schedules."
        requires :dateref, type: Date, desc: "Data references."
        optional :dayofweek, type: Integer, desc: "Day of week."
        requires :start, type: Time, desc: "Time start Schedules."
        requires :end, type: Time, desc: "Time end Schedules."
        requires :price, type: Float, desc: "Price Schedules."
        optional :active, default: true, type: Boolean, desc: "Schedules Active?"
        optional :discounts, type: Integer, desc: "Discounts ID."
      end
      post do
        guard!
        space = GogoparkSpaceschedule.new do |u|
          u.gogopark_address_id = params[:address]
          u.dateref = params[:dateref]
          u.dayofweek = params[:dayofweek]
          u.start = params[:start]
          u.end = params[:end]
          u.price = params[:price]
          u.maxreserve = params[:maxreserve]
          u.name = params[:name]
          u.description = params[:description]
          u.active = params[:active]
          u.gogopark_discounts_id = params[:discounts]
        end
        if space.save
            space
        else
            space.errors.full_messages
        end
      end
      
      desc "Update a Schedules Address."
      params do
        requires :id, type: String, desc: "Schedules ID."
        requires :address, type: Integer, desc: "Address Id."
        requires :dateref, type: DateTime, desc: "Data references."
        requires :dayofweek, type: Integer, desc: "Day of week."
        requires :start, type: Time, desc: "Time start Schedules."
        requires :end, type: Time, desc: "Time end Schedules."
        requires :price, type: Float, desc: "Price Schedules."
        optional :discounts, type: Integer, desc: "Discounts ID."
      end
      put ':id' do
        guard!
        GogoparkSpaceschedule.find(params[:id]).update({
          gogopark_address_id: params[:address],
          dateref: params[:dateref],
          dayofweek: params[:dayofweek],
          start: params[:start],
          end: params[:end],
          price: params[:price],
          gogopark_discounts_id: params[:discounts],
        })
      end
      
      desc "Delete a Schedules Address."
      params do
        requires :address, type: Integer, desc: "Address ID."
      end
      delete do
        guard!
        GogoparkSpaceschedule.destroy_all(:gogopark_address_id => params[:address])
      end
  end
end