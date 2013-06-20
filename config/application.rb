require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module Studimetrics
  class Application < Rails::Application
    config.active_record.default_timezone = :utc
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true
    config.assets.initialize_on_precompile = false
    config.assets.precompile += ['admin.css']
    config.assets.version = '1.0'
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
  end
end
