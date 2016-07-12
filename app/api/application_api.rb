class ApplicationAPI < Grape::API
  include APIGuard

  format :json

  helpers do
    def apartment!
        domain = request.host
        app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../config/application.yml', __FILE__)).read).result)[Rails.env]
        domains = "."+app_config['host']
        hosts = domain.sub!(domains, "")

        Apartment::Tenant.switch!(hosts)
        PaperTrail.controller_info = { ip: request.env["REMOTE_HOST"] }
    end
  end

  mount V1::Base
end
