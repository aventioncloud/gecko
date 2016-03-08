class DocumentationController < ApplicationController

  def index
    app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../config/application.yml', __FILE__)).read).result)[Rails.env]
    domain = request.host
    subdomain = domain.sub!(".#{app_config['host']}", "")
    @uri = "http://#{subdomain}.#{app_config['host']}:#{app_config['port']}/"
    @applications = Doorkeeper::Application.all
    render layout: false
  end

  def o2c
    render layout: false
  end

  def authorize
    @access_code = params[:code]
    @access_grant = Doorkeeper::AccessGrant.where(resource_owner_id: current_user.id, token: @access_code).last
    @application = @access_grant.application if @access_grant.present?
  end


end
