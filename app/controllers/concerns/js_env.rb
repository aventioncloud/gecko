module JsEnv
  extend ActiveSupport::Concern
  included do
    helper_method :js_env
  end

  def js_env
    app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../../config/application.yml', __FILE__)).read).result)[Rails.env]
    domain = request.host
    #binding.pry
    subdomain = domain.sub!(".#{app_config['host']}", "")
    uri = "http://#{subdomain}.#{app_config['host']}:#{app_config['port']}/"
    Apartment::Database.switch!("public")
    app = Application.where(:redirect_uri => uri).first
    uri = "#{subdomain}.#{app_config['host']}:#{app_config['port']}/"
    data = {
      host: uri,
      application_id: app.uid
    }

    <<-EOS.html_safe
      <script type="text/javascript">
        shared = angular.module('geckoCliApp')
        shared.constant('Rails', #{data.to_json})
      </script>
    EOS
  end
end