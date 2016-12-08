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

    def content_lead! item,versions, index
      itemnow = versions[index + 1] rescue nil
      if itemnow.nil?
        ""
      else
         object = itemnow.reify(options = {})
         username = User.find(object.user_id)
         leadstatus = LeadStatus.find(object.leadstatus_id)
        "Consultor: #{username.name}, Data Atualização: #{item.created_at.strftime("%d/%m/%Y %H:%M")}, Status Lead: #{leadstatus.name}"
      end
    end
  end

  mount V1::Base
end
