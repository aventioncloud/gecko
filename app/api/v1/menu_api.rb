module V1
  class MenuAPI < Base
    namespace "menu"
    
      get '/' do
        guard!
        #useracess = current_user
        #binding.pry
        
        ary = Array.new
        
        PlatformMenuRoles.where(role_id: current_user.roles).find_each do |menuroles|
          ary << PlatformMenu.find(menuroles.menu_id)
        end
        
        ary
      end
  end
end