module JsEnv
  extend ActiveSupport::Concern
  included do
    helper_method :js_env
  end

  def js_env
    app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../../config/application.yml', __FILE__)).read).result)[Rails.env]
    data = {
      host: request.host+':3001',
      application_id: app_config['application_id']
    }

    <<-EOS.html_safe
      <script type="text/javascript">
        shared = angular.module('geckoCliApp')
        shared.constant('Rails', #{data.to_json})
      </script>
    EOS
  end
end