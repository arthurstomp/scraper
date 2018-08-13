FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /scraper
WORKDIR /scraper
COPY Gemfile /scraper/Gemfile
COPY Gemfile.lock /scraper/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /scraper
