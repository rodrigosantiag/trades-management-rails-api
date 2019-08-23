source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1', '>= 5.1.7'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3.13'
# Use Puma as the app server
gem 'puma', '~> 3.0'
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
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'listen', '~> 3.0.5'
  # Factory Bot
  gem "factory_bot_rails"

  # Faker
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Mysql
gem 'mysql2'

# Devise
gem 'devise'

# Devise Token Auth
gem 'omniauth'
gem 'devise_token_auth'

# Active Model Serializer for JSON API pattern
gem 'active_model_serializers', '~> 0.10.0'

# CORS
gem 'rack-cors'

# Ransack
gem 'ransack', github: 'activerecord-hackery/ransack'

# Pagination
gem 'kaminari'
gem 'api-pagination'

# Rails 5.2
gem 'bootsnap', '~> 1.4', '>= 1.4.4'
