source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.rc2'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0.rc2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'bourbon'
gem 'clearance', github: 'thoughtbot/clearance'
gem 'dalli'
gem 'flutie'
gem 'high_voltage'
gem 'neat'
gem 'normalize-rails'
gem 'rack-timeout'
gem 'redis'
gem 'sidekiq'
gem 'simple_form'
gem 'slim'
gem 'unicorn'
gem 'jquery-rails'
gem 'turbolinks'
gem 'honeybadger'
gem 'inherited_resources', github: 'josevalim/inherited_resources'
gem 'cocoon', github: 'nathanvda/cocoon'
gem 'acts_as_list', github: 'philippfranke/acts_as_list', ref: 'd178bb314246cdc93d5ddb8e4d1aedd22ee31858'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

group :development do
  gem 'foreman'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'mailcatcher'
  gem 'pry'
end

group :test do
  gem 'bourne', require: false
  gem 'poltergeist'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'timecop'
end

group :staging, :production do
  gem 'newrelic_rpm'
  gem 'rails_on_heroku'
end
