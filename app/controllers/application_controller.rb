class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include JsEnv
  
  protect_from_forgery

  def access_denied(exception)
    redirect_to admin_organizations_path, :alert => exception.message
  end

  before_filter :load_schema, :set_mailer_host, :load_init, :set_timezone
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      # Season this regexp to taste. I prefer to treat iPad as non-mobile.
      #(request.user_agent =~ /Mobile|webOS) && (request.user_agent !~ /iPad/)
    end
  end
  helper_method :mobile_device?

  protected

  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:accept_invitation).concat([:email])
  end

  private
  
  def set_timezone
    Time.zone = 'Brasilia'
  end
  
  def load_init
    app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../config/application.yml', __FILE__)).read).result)[Rails.env]
    @theme = app_config['theme']
    @title = app_config['title']
  end

  def load_schema
    #binding.pry
    Apartment::Database.switch('public')
    return unless request.subdomain.present?

    if current_account
      Apartment::Database.switch(current_account.subdomain)
    else
      redirect_to root_url(subdomain: false)
    end
  end

  def current_account
    subdoma = request.subdomain.sub! '.unicooprj', ''
    @current_account ||= Account.find_by(subdomain: subdoma)
  end
  helper_method :current_account

  def set_mailer_host
    app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../config/application.yml', __FILE__)).read).result)[Rails.env]
    subdomain = current_account ? "#{current_account.subdomain}." : ""
    uri = "http://#{subdomain}.#{app_config['host']}:#{app_config['port']}/"
    ActionMailer::Base.default_url_options[:host] = uri#"#{subdomain}kurumin.xyz:3001"
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_invite_path_for(resource)
    users_path
  end
end
