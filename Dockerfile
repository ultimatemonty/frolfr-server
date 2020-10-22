FROM ruby:2.5-alpine

WORKDIR /app

RUN mkdir -p /app/tmp/pids
RUN chmod 777 /app/tmp/pids

# Install packages
RUN apk update && apk add build-base gcc wget git libpq postgresql-client

# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

# Install bundler
RUN gem install bundler

# Install deps
RUN bundle install

# Copy the app
ADD . /app

CMD ["/bin/ash"]