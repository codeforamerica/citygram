FROM ruby:2.2.2-onbuild

RUN apt-get install curl
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install --yes nodejs
