module V1
  class ExtendAPI < Base
    namespace "extend"
    
      get '/' do
        ExtendSetting.all()
      end
  end
end