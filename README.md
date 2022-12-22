# Trades Management API

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
- `rails db:create`
- `rails db:migrate`
- `rails s -b '0.0.0.0'`

### Run tests
- `rspec`

## Requirements (container development)

* Docker
* Docker compose (if you prefer, Docker Desktop includes Docker and Docker compose)

### Build

- `docker compose build`

### Start containers

- `docker compose up`

### Run migrations in container

- `docker compose run api rails db:create`
- `docker compose run api rails db:migrate`
