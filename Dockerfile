# syntax=docker/dockerfile:1
FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app
COPY . .
RUN cd /app; \
    gem install bundler; \
    bundle install

# Copy pre-commit script to .git/hooks
COPY scripts/pre-commit .git/hooks

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running image
CMD ["rails", "server", "-b", "0.0.0.0"]
