# syntax=docker/dockerfile:1
FROM ruby:3.1.2 AS base
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn nano --no-install-recommends && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
# Configure the main process to run when running image
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM base AS development
RUN cd /app; \
    gem install bundler; \
    bundle install

FROM base AS production
ARG APP_ENV=production
ENV RAILS_ENV=$APP_ENV
ENV RAKE_ENV=$APP_ENV
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

ARG SECRET_KEY_BASE_ARG=null
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE_ARG
ARG DATABASE_URL_ARG=null
ENV DATABASE_URL=$DATABASE_URL_ARG

RUN cd /app; \
    gem install bundler; \
    bundle config --global frozen 1; \
    bundle config set without 'development test'; \
    bundle install; \
    bundle exec rails assets:precompile
