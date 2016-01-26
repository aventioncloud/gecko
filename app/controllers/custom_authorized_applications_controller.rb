class CustomAuthorizedApplicationsController < Doorkeeper::ApplicationController
  before_filter :authenticate_resource_owner!
  
  before_filter :load_schema
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

  def index
      binding.pry
    @applications = Doorkeeper::Application.authorized_for(current_resource_owner)
  end

  def destroy
      binding.pry
    Doorkeeper::AccessToken.revoke_all_for params[:id], current_resource_owner
    redirect_to oauth_authorized_applications_url, :notice => I18n.t(:notice, :scope => [:doorkeeper, :flash, :authorized_applications, :destroy])
  end
end
