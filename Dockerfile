FROM ruby:2.2.3

# ExecJS runtime -- not optimal
RUN apt-get update && apt-get install curl
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install --yes nodejs

RUN mkdir -p /usr/src/app/citygram
WORKDIR /usr/src/app/citygram

COPY Gemfile /usr/src/app/citygram/
COPY Gemfile.lock /usr/src/app/citygram/

RUN /usr/local/bundle/bin/bundle install

WORKDIR /usr/src/app/citygram

# docker-compose will mount the working directory as the volume during that pass