# Citygram NYC [![Build Status](http://img.shields.io/travis/codeforamerica/citygram.svg)][travis] [![Dependency Status](http://img.shields.io/gemnasium/codeforamerica/citygram.svg)][gemnasium] [![Code Climate](http://img.shields.io/codeclimate/github/codeforamerica/citygram.svg)][codeclimate]

[travis]: https://travis-ci.org/codeforamerica/citygram
[gemnasium]: https://gemnasium.com/codeforamerica/citygram
[codeclimate]: https://codeclimate.com/github/codeforamerica/citygram

This is fork of Citygram for New York City. You can receive alerts for 311 requests and vehicle collisions in your neighborhood! _Visit [Citygram.nyc](http://www.citygram.nyc)_

__Citygram__ is a geographic notification platform designed to work with open government data. It allows residents to designate area(s) of a city they are interested in and subscribe to one or more topics. When an event for a desired topic occurs in the subscriber's area of interest, a notification (email, SMS,or  [webhook](http://en.wikipedia.org/wiki/Webhook)) is delivered. Citygram is a [Code for America](https://github.com/codeforamerica) project by the [Charlotte](http://team-charlotte.tumblr.com/) and [Lexington](http://teambiglex.tumblr.com/) teams for the [2014 fellowship](http://www.codeforamerica.org/geeks/our-geeks/2014-fellows/).

### Why are we doing this?

We believe that there is an opportunity to help residents better understand what’s going on in their area, when it’s going to happen, and why. By providing timely information to residents in areas that are relevant to them, the city can be proactive instead of reactive, build trust through transparency, and increase civic engagement across the board.

### Who is this made by?

See the [contributors list](https://github.com/codeforamerica/citygram/graphs/contributors).

### Technical Overview

Citygram is a web application written in Ruby.

* Web: [Sinatra](https://github.com/sinatra/sinatra), [Grape](https://github.com/intridea/grape), [Sprockets](https://github.com/sstephenson/sprockets)
* Web server: [Unicorn](http://unicorn.bogomips.org/)
* Database/models: [PostgreSQL](http://www.postgresql.org/), [PostGIS](http://postgis.net/), [Sequel](https://github.com/jeremyevans/sequel/)
* Job Queue: [Redis](http://redis.io/), [Sidekiq](https://github.com/mperham/sidekiq)
* Tests: [RSpec](https://github.com/rspec), [FactoryGirl](https://github.com/thoughtbot/factory_girl), [Rack::Test](https://github.com/brynary/rack-test)

### Setup

* Install Redis - `brew install redis`
* [Install PostgreSQL](https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md)
* [Install Ruby](https://github.com/codeforamerica/howto/blob/master/Ruby.md)

In the command line, run the following:

```
git clone https://github.com/codeforamerica/citygram.git
cd citygram
cp .env.sample .env
gem install bundler
bundle install
rake db:create db:migrate
rake db:create db:migrate DATABASE_URL=postgres://localhost/citygram_test
rake # run the test suite
bundle exec rackup
```

To boot up the complete application and run background jobs in development:

```
bundle exec foreman start -f Procfile.dev
```
