# Trades Management API

![Ruby](https://img.shields.io/badge/ruby-3.1.2-red)
![RoR](https://img.shields.io/badge/rails-7-red)
![Lint and tests](https://github.com/rodrigosantiag/trades-management-rails-api/actions/workflows/tests.yml/badge.svg)
[![Coverage](https://rodrigosantiag.github.io/trades-management-rails-api/badge.svg)](https://github.com/rodrigosantiag/trades-management-rails-api)
![Languages](https://img.shields.io/github/languages/count/rodrigosantiag/trades-management-rails-api)
![Top language](https://img.shields.io/github/languages/top/rodrigosantiag/trades-management-rails-api)
![Total lines](https://img.shields.io/tokei/lines/github/rodrigosantiag/trades-management-rails-api)

API to serve personal trades management system

## Requirements (local development)

* Ruby 2.3.1

* Rails 7.x.x

* Bundler 2.3.6

* Mailcatcher

* Postgres (latest)

### Install and run

Simply run commands:
- `gem install bundler`
- `gem install mailcatcher`
- `bundle install`
- `mailcatcher`
- `bundle exec rails db:create`
- `bundle exec rails db:migrate`
- `bundle exec rails s -b '0.0.0.0'`

### Run tests
- `bundle exec rspec`

## Requirements (container development)

* Docker
* Docker compose (if you prefer, Docker Desktop includes Docker and Docker compose)

### Build

- `docker compose build`

### Start containers

- `docker compose up`

### Run migrations in container

- `docker compose run api bundle exec rails db:create`
- `docker compose run api bundle exec rails db:migrate`

### Lint
To code linting, the project uses [Rubocop](https://github.com/rubocop/rubocop). If you don't have Rubocop GEM installed, first you should install it: `gem install rubocop`

After that, just run `bundle exec rubocop` to lint code.
