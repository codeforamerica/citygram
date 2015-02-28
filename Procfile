web: bundle exec unicorn -c ./config/unicorn.rb
worker: bundle exec sidekiq -r ./app.rb
redis: redis-server /usr/local/etc/redis.conf
