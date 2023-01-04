# syntax=docker/dockerfile:1
FROM ruby:3.1.2 AS base
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app
COPY . .

FROM base AS development
RUN cd /app; \
    gem install bundler; \
    bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running image
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM base AS production
RUN rm -rf /var/lib/apt/lists/*

ARG APP_ENV=production
ENV RAILS_ENV=$APP_ENV
ENV RAKE_ENV=$APP_ENV
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ARG SECRET_KEY_BASE_ARG=null
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE_ARG
ARG DATABASE_URL=null
ENV DATABASE_URL=$DATABASE_URL

RUN cd /app; \
    gem install bundler; \
    bundle config --global frozen 1; \
    bundle config set without 'development test'; \
    bundle install; \
    bundle exec rails assets:precompile; \
    bundle exec rails db:create RAILS_ENV=$RAILS_ENV; \
    bundle exec rails db:migrate RAILS_ENV=$RAILS_ENV

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
