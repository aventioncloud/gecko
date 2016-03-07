class ApplicationAPI < Grape::API
  include APIGuard

  format :json
  
  helpers do
    def apartment!
        domain = request.host
        hosts = domain.sub!(".unicooprj.com.br", "")
        Apartment::Tenant.switch!(hosts)
        PaperTrail.controller_info = { ip: request.env["REMOTE_HOST"] }
    end
  end

  mount V1::Base
end
