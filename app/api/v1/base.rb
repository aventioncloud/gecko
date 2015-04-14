module V1
  class Base < ApplicationAPI
    version "v1", :using => :path

    mount SampleAPI
    mount SecretAPI
    mount ExtendAPI
    mount MenuAPI
    mount GroupAPI
    mount TeamAPI
    mount SpaceAPI
    mount AddressAPI
    mount ImageaddressAPI
    mount FeaturesAPI
    mount SchedulesAPI
    mount VerificationAPI
    mount SearchAPI
    mount PaymentAPI
    
    add_swagger_documentation
  end
end
