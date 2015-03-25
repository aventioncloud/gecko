module V1
  class Base < ApplicationAPI
    version "v1", :using => :path

    mount SampleAPI
    mount SecretAPI
    mount ExtendAPI
    mount MenuAPI
    mount GroupAPI
    
    add_swagger_documentation
  end
end
