require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = 'test'

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'bourne'
require 'sidekiq'
require 'sidekiq/testing'
require 'paperclip/matchers'
require 'webmock/rspec'
require 'mock_redis'
require 'stripe_mock'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryGirl::Syntax::Methods
  config.mock_with :mocha
  config.infer_base_class_for_anonymous_controllers = false
  config.use_transactional_fixtures = false
  config.order = "random"

  config.before(:each) do
    StripeMock.start
  end

  config.after(:each) do
    REDIS.flushdb
    StripeMock.stop
  end
end

require 'capybara/poltergeist'
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true)
end

Capybara.javascript_driver = :poltergeist
# Capybara.javascript_driver = :poltergeist_debug

WebMock.disable_net_connect!(allow_localhost: true)

Object.__send__(:remove_const, :REDIS)
Object.const_set(:REDIS, MockRedis.new)
