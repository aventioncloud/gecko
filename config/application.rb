require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Oauth2ApiSample
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    config.middleware.insert_before "ActionDispatch::Static", "Rack::Cors" do
      # Permit CORS from any origin, only in the API route
      allow do
        origins '*'
        resource '/api/*', :headers => :any
      end
    end

    config.paths.add "app/api", glob: "**/*.rb"
    config.paths.add "app/services", glob: "**/*.rb"
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]
    config.autoload_paths += Dir["#{Rails.root}/app/services/*"]
    config.cache_store = :redis_store, 'redis://127.0.0.1:6379/0/cache', { expires_in: 90.minutes }
    
    config.assets.paths += Dir["#{Rails.root}/vendor/views/*"].sort_by { |dir| -dir.size }
    config.assets.paths += Dir["#{Rails.root}/vendor/img/*"].sort_by { |dir| -dir.size }
    config.assets.paths += Dir["#{Rails.root}/vendor/assets/bower_components/*"].sort_by { |dir| -dir.size }
    config.assets.paths += Dir["#{Rails.root}/app/assets/lib/*"].sort_by { |dir| -dir.size }
    config.assets.paths += Dir["#{Rails.root}/app/assets/theme/*"].sort_by { |dir| -dir.size }
    
    config.action_mailer.delivery_method = :smtp
    # SMTP settings for gmail
    config.action_mailer.smtp_settings = {
     :address              => ENV['smtp_host'],
     :port                 => ENV['smtp_port'],
     :user_name            => ENV['smtp_user'],
     :password             => ENV['smtp_password'],
     :authentication       => "plain",
    :enable_starttls_auto => true
    }
  end
end
