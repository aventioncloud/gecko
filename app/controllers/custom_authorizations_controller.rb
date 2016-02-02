class CustomAuthorizationsController < Doorkeeper::ApplicationsController

  before_filter :authenticate_resource_owner!
  #before_filter :load_schema
    
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
  #helper_method :current_account

    def new
      if pre_auth.authorizable?
        if skip_authorization? || matching_token?
          auth = authorization.authorize
          redirect_to auth.redirect_uri
        else
          render :new
        end
      else
        render :error
      end
    end

    # TODO: Handle raise invalid authorization
    def create
      redirect_or_render authorization.authorize
    end

    def destroy
      redirect_or_render authorization.deny
    end

    private

    def matching_token?
      AccessToken.matching_token_for pre_auth.client,
                                     current_resource_owner.id,
                                     pre_auth.scopes
    end

    def redirect_or_render(auth)
      if auth.redirectable?
        redirect_to auth.redirect_uri
      else
        render json: auth.body, status: auth.status
      end
    end

    def pre_auth
      Apartment::Database.switch('public')
      @pre_auth ||= Doorkeeper::OAuth::PreAuthorization.new(Doorkeeper.configuration,
                                                server.client_via_uid,
                                                params)
    end

    def authorization
      @authorization ||= strategy.request
    end

    def strategy
      @strategy ||= server.authorization_request pre_auth.response_type
    end
end