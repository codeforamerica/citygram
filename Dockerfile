FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql
RUN mkdir /myapp
WORKDIR /myapp
ADD . /myapp
RUN bundle install
