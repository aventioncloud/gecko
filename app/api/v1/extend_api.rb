module V1
  class ExtendAPI < Base
    namespace "extend"
    authorize_routes!
    
      get '/' do
        ExtendSetting.all()
      end
  end
end