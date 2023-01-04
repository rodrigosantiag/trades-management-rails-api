# syntax=docker/dockerfile:1
FROM ruby:3.1.2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn nano --no-install-recommends && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .

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
