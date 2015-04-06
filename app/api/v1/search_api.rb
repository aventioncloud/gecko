module V1
  class SearchAPI < Base
    namespace "search"
    desc "Return all Address."
      params do
        optional :address, type: String, desc: "Address."
        optional :ip, type: String, desc: "IP."
        optional :latitude, type: Float, desc: "Latitude."
        optional :longitude, type: Float, desc: "Longitude."
      end 
      get '/' do
        guard!
        if params[:latitude] != nil && params[:longitude] != nil
            GogoparkAddress.within(5, :origin => [params[:latitude], params[:longitude]])
        elsif params[:address] != nil
            #GogoparkAddress.geo_scope(5, :origin => params[:address])
            begin
                $googleURI = "https://maps.googleapis.com/maps/api/geocode/json"
                uri = URI($googleURI)
                paramms = { :address => params[:address], :sensor => "false",  :key => "AIzaSyAF6nlGf5Llp1xP-Zbi2HoI42yJt6E8M7I" }
                uri.query = URI.encode_www_form(paramms)
                response = Net::HTTP.get_response(uri)
                data = response.body
                code = ActiveSupport::JSON.decode(data)
                if code["status"] == "OK"
                    gogoaddress = GogoparkAddress.within(5, :origin => [code["results"][0]["geometry"]["location"]["lat"], code["results"][0]["geometry"]["location"]["lng"]])
                    #endereco = gogoaddress.joins(:cidade).joins(:gogopark_spaceverifications).joins("LEFT OUTER JOIN gogopark_spaceimages ON gogopark_spaceimages.gogopark_address_id = gogopark_addresses.id").where(:active => true, :gogopark_spaceverifications => {:spaceverified => true}).select("gogopark_addresses.*, cidades.nome as cidade")
                    endereco = gogoaddress.joins(:cidade).joins(:gogopark_spaceverifications).where(:active => true, :gogopark_spaceverifications => {:spaceverified => true}).select("gogopark_addresses.*, cidades.nome as cidade")
                    endereco
                else
                    { notfound: "Address not found!" }
                end
            rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
                    Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
                { erro: e }
            end
            #Geokit::Geocoders::GoogleGeocoder.client_id
        end
      end
  end
end