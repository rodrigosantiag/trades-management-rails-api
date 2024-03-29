# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.2.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.7'
# Use pg as the database for Active Record (Development and Production)
gem 'pg', '>= 0.18', '< 2.0', group: %i[development production]

# Use sqlite3 for Test
gem 'sqlite3', group: :test

# Use Puma as the app server
gem 'puma', '~> 6.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :test do
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'simplecov-shields-badge', require: false
end

gem 'rspec-rails', '~> 6.0.3', group: %i[development test production]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # JSON API for rspec
  gem 'jsonapi-rspec'
  gem 'listen', '~> 3.8.0'
  # Factory Bot
  gem 'factory_bot_rails'

  # Faker
  gem 'faker'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more:
  # https://github.com/rails/spring  gem 'spring'
  gem 'overcommit'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Devise
gem 'devise', '~> 4.9'

# Devise Token Auth
gem 'devise_token_auth'
gem 'omniauth'

# Active Model Serializer for JSON API pattern
# gem 'active_model_serializers', '~> 0.10.0'

# JSON API Rails
gem 'jsonapi-rails'

# CORS
gem 'rack-cors'

# Ransack
gem 'ransack'

# Pagination
gem 'api-pagination'
gem 'kaminari'

# Rails 5.2
gem 'bootsnap', '~> 1.16'

# Webpacker
gem 'webpacker'

# Sidekiq
gem 'sidekiq'

group :production do
  gem 'sendgrid-ruby'
end
