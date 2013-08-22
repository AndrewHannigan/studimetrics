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

  config.after(:each) do
    REDIS.flushdb
  end
end

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
WebMock.disable_net_connect!(allow_localhost: true)

Object.__send__(:remove_const, :REDIS)
Object.const_set(:REDIS, MockRedis.new)
