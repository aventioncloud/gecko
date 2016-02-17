class PagesController < ApplicationController
  #before_action :authenticate_user!, :only => :welcome

  def welcome
    app_config = YAML.load(ERB.new(File.new(File.expand_path('../../../config/application.yml', __FILE__)).read).result)[Rails.env]
    @theme = app_config['theme']
  end

  def secret
  end
end
