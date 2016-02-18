module V1
  class ProductAPI < Base
    namespace "product"
    
      desc "Return all Product."
      get '/', authorize: ['read', 'Product'] do
        apartment!
        #binding.pry
        
        Product.all
      end
      
      desc "Return one Product."
      params do
        requires :id, type: Integer
      end
      route_param :id do
        get '', authorize: ['read', 'Product'] do
          apartment!
          Product.find(params[:id])
        end
      end
      
      desc "Create a Product."
      params do
        requires :name, type: String, desc: "Product name."
      end
      post '', authorize: ['create', 'Product'] do
        apartment!
        
        item = Product.create(name: params[:name])
        
        if item.save
            item
        else
            item.errors.full_messages
        end
      end
      
      desc "Update a Product."
      params do
        requires :id, type: String, desc: "Product ID."
        requires :name, type: String, desc: "Product name."
      end
      put ':id' do
        apartment!
        Product.find(params[:id]).update({name: params[:name]})
      end
      
      desc "Delete a Product."
      params do
        requires :id, type: String, desc: "Product ID."
      end
      delete ':id' do
        apartment!
        Product.find(params[:id]).destroy
      end
  end
end