class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include JsEnv
  
  protect_from_forgery

  def access_denied(exception)
    redirect_to admin_organizations_path, :alert => exception.message
  end

  before_filter :load_schema, :set_mailer_host
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:accept_invitation).concat([:email])
  end

  private

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
    @current_account ||= Account.find_by(subdomain: request.subdomain)
  end
  helper_method :current_account

  def set_mailer_host
    subdomain = current_account ? "#{current_account.subdomain}." : ""
    ActionMailer::Base.default_url_options[:host] = "#{subdomain}kurumin.xyz:3001"
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_invite_path_for(resource)
    users_path
  end
end
