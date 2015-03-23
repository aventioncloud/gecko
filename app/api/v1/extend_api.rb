module V1
  class ExtendAPI < Base
    namespace "extend"
    
      get '/' do
        guard!
        useracess = current_user
        binding.pry
        
        ExtendSetting.all()
      end
  end
end