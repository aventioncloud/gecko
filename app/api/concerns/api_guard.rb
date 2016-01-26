# Guard API with OAuth 2.0 Access Token

require 'rack/oauth2'

module APIGuard
  extend ActiveSupport::Concern

  included do |base|
    # OAuth2 Resource Server Authentication
    use Rack::OAuth2::Server::Resource::Bearer, 'The API' do |request|
      # The authenticator only fetches the raw token string

      # Must yield access token to store it in the env
      request.access_token
    end

    helpers HelperMethods

    install_error_responders(base)
  end

  # Helper Methods for Grape Endpoint
  module HelperMethods
    
    def fetch_users
      #binding.pry
      #domain = request.host
      #hosts = domain.sub!(".dokkuapp.com", "")
      users =  User.all.to_json
      #if users.nil?
      #  users = User.all.to_json
      #  $redis.set("users", users)
        #$redis.expire("categories",3.hour.to_i)
      #end
      @users = JSON.load users
    end
    def find_byid(id)
      #binding.pry
      @users =  fetch_users()
      @user = @users.find { |h| h['id'] == id }
    end
    
    def find_permission(id, subject_class, action)
      #binding.pry
      domain = request.host
      hosts = domain.sub!(".kurumin.xyz", "")
      Apartment::Tenant.switch!(hosts)
      
      @permissions = Role.joins(:permissions).select("permissions.*").where("roles.id = ? and permissions.subject_class = ? and permissions.action = ?", id, subject_class, action)
      @permissions
    end
    
    # Invokes the doorkeeper guard.
    #
    # If token string is blank, then it raises MissingTokenError.
    #
    # If token is presented and valid, then it sets @current_user.
    #
    # If the token does not have sufficient scopes to cover the requred scopes,
    # then it raises InsufficientScopeError.
    #
    # If the token is expired, then it raises ExpiredError.
    #
    # If the token is revoked, then it raises RevokedError.
    #
    # If the token is not found (nil), then it raises TokenNotFoundError.
    #
    # Arguments:
    #
    #   scopes: (optional) scopes required for this guard.
    #           Defaults to empty array.
    #
    
    def guarddommain!(domain)
      hosts = domain.sub!(".kurumin.xyz", "")
      #binding.pry
      Apartment::Tenant.switch!(hosts)
      guard!
    end
    
    def auth_routes!
      token_strings = ""
    end 
    
    def guard!(scopes: [])
      Apartment::Database.switch('public')
      #binding.pry
      #
      token_string = get_token_string()
      #binding.pry
      if token_string.blank?
        raise MissingTokenError

      elsif (access_token = find_access_token(token_string)).nil?
        raise TokenNotFoundError

      else
        case validate_access_token(access_token, scopes)
        when Oauth2::AccessTokenValidationService::INSUFFICIENT_SCOPE
          raise InsufficientScopeError.new(scopes)

        when Oauth2::AccessTokenValidationService::EXPIRED
          raise ExpiredError

        when Oauth2::AccessTokenValidationService::REVOKED
          raise RevokedError

        when Oauth2::AccessTokenValidationService::VALID
          @current_user = find_byid(access_token.resource_owner_id)
          PaperTrail.whodunnit = @current_user["id"]
        end
      end
    end

    def current_user
      #binding.pry
      if get_token_string() != nil
        token_string = get_token_string()
        access_token = find_access_token(token_string)
        @current = find_byid(access_token.resource_owner_id)
        if @users != nil
          @current_user = @users[0]
        else
          @current_user = nil
        end
        #print 'oauu'
      end
      @current_user
    end

    private
    def get_token_string
      # The token was stored after the authenticator was invoked.
      # It could be nil. The authenticator does not check its existence.
      request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]
    end

    def find_access_token(token_string)
      #binding.pry
      Apartment::Database.switch!("public")
      #AccessToken.authenticate(token_string)
      Doorkeeper::AccessToken.authenticate(token_string)
    end

    def validate_access_token(access_token, scopes)
      #binding.pry
      Oauth2::AccessTokenValidationService.validate(access_token, scopes: scopes)
    end
  end

  module ClassMethods
    # Installs the doorkeeper guard on the whole Grape API endpoint.
    #
    # Arguments:
    #
    #   scopes: (optional) scopes required for this guard.
    #           Defaults to empty array.
    #
    def guard_all!(scopes: [])
      before do
        guard! scopes: scopes
      end
    end
    
    def authorizes_routes!
      before do
        guard!
        opts = env['api.endpoint'].options[:route_options]
        @current_user = current_user
        if @current_user != nil and opts[:authorize] != nil
          #binding.pry
          permissions = find_permission(@current_user["roles"], opts[:authorize][1], opts[:authorize][0])
          if permissions.length == 0
            error!('401 Unauthorized', 401)
          end
        end
      end
    end 

    private
    def install_error_responders(base)
      error_classes = [ MissingTokenError, TokenNotFoundError,
                        ExpiredError, RevokedError, InsufficientScopeError]

      base.send :rescue_from, *error_classes, oauth2_bearer_token_error_handler
    end

    def oauth2_bearer_token_error_handler
      Proc.new {|e|
        response = case e
          when MissingTokenError
            Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new

          when TokenNotFoundError
            Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
              :invalid_token,
              "Bad Access Token.")

          when ExpiredError
            Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
              :invalid_token,
              "Token is expired. You can either do re-authorization or token refresh.")

          when RevokedError
            Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
              :invalid_token,
              "Token was revoked. You have to re-authorize from the user.")

          when InsufficientScopeError
            # FIXME: ForbiddenError (inherited from Bearer::Forbidden of Rack::Oauth2)
            # does not include WWW-Authenticate header, which breaks the standard.
            Rack::OAuth2::Server::Resource::Bearer::Forbidden.new(
              :insufficient_scope,
              Rack::OAuth2::Server::Resource::ErrorMethods::DEFAULT_DESCRIPTION[:insufficient_scope],
              { :scope => e.scopes})
          end

        response.finish
      }
    end
  end

  #
  # Exceptions
  #

  class MissingTokenError < StandardError; end

  class TokenNotFoundError < StandardError; end

  class ExpiredError < StandardError; end

  class RevokedError < StandardError; end

  class InsufficientScopeError < StandardError
    attr_reader :scopes
    def initialize(scopes)
      @scopes = scopes
    end
  end
end