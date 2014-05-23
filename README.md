georelevent
===========

Geographically relevant notification platform (georelevent is a working title)


## Setup

* [Install PostgreSQL](https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md)
* [Install Ruby](https://github.com/codeforamerica/howto/blob/master/Ruby.md)

```
git clone https://github.com/codeforamerica/georelevent.git
cd georelevent
cp .env.sample .env
gem install bundler
bundle install
rake db:create db:migrate
rake db:create db:migrate DATABASE_URL=postgres://localhost/georelevent_test
rake # run the test suite
rackup
```
