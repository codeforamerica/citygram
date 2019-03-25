FROM node:6.11 as nodejs
FROM ruby:2.5.1

COPY --from=nodejs /usr/local/lib/node_modules /usr/local/lib/node_modules/
COPY --from=nodejs /usr/local/include/node /usr/local/include/node/
COPY --from=nodejs /usr/local/bin /usr/local/bin/
COPY --from=nodejs /opt/yarn /opt/yarn


RUN     mkdir -p /app
ENV     PORT         9292
ENV     DATABASE_URL postgres://postgres@citygram_db/citygram_development
COPY    docker/citygram/env.docker /app/.env
COPY    Gemfile Gemfile.lock /app/
WORKDIR /app
RUN     bundle install
COPY    . /app/

CMD     bundle exec rackup -o 0.0.0.0 -p $PORT
