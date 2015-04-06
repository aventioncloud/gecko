module V1
  class FeaturesAPI < Base
    namespace "features"
    
      desc "Return all Features."
      params do
        requires :address, type: Integer
      end
      get '/' do
        guard!
        #binding.pry
        
        GogoparkSpacefeatures.where(gogopark_address_id: params[:address])
      end
      
      desc "Return one Features."
      params do
        requires :id, type: Integer
      end
      route_param :id do
      get do
          guard!
          GogoparkSpacefeatures.find(params[:id])
        end
      end
      
      desc "Create a Features Address."
      params do
        requires :address, type: Integer, desc: "Address Id."
        requires :contactphone, type: String, desc: "Contactphone."
        requires :scheduleprivacy, type: Boolean, default: true, desc: "Scheduleprivacy."
        requires :maxheight, type: Integer, desc: "Max Height(m)."
        requires :eletricrecharge, type: Boolean, desc: "Eletricrecharge."
        requires :others, type: String, desc: "Others."
      end
      post do
        guard!
        space = GogoparkSpacefeatures.new do |u|
          u.gogopark_address_id = params[:address]
          u.contactphone = params[:contactphone]
          u.scheduleprivacy = params[:scheduleprivacy]
          u.maxheight = params[:maxheight]
          u.eletricrecharge = params[:eletricrecharge]
          u.others = params[:others]
        end
        if space.save
            space
        else
            space.errors.full_messages
        end
      end
      
      desc "Update a Features Address."
      params do
        requires :id, type: String, desc: "Team ID."
        requires :address, type: Integer, desc: "Address Id."
        requires :contactphone, type: String, desc: "Contactphone."
        requires :scheduleprivacy, type: Boolean, desc: "Scheduleprivacy."
        requires :maxheight, type: Integer, desc: "Max Height."
        requires :eletricrecharge, type: Boolean, desc: "Eletricrecharge."
        requires :others, type: String, desc: "Others."
      end
      put ':id' do
        guard!
        GogoparkSpacefeatures.find(params[:id]).update({
          gogopark_address_id: params[:address],
          contactphone: params[:contactphone],
          scheduleprivacy: params[:scheduleprivacy],
          maxheight: params[:maxheight],
          eletricrecharge: params[:eletricrecharge],
          others: params[:others]
        })
      end
      
      desc "Delete a Features Address."
      params do
        requires :address, type: Integer, desc: "Address ID."
      end
      delete do
        guard!
        GogoparkSpacefeatures.destroy_all(:gogopark_address_id => address)
      end
  end
end