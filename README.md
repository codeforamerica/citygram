# Citygram [![Build Status](http://img.shields.io/travis/codeforamerica/citygram.svg)][travis] [![Dependency Status](http://img.shields.io/gemnasium/codeforamerica/citygram.svg)][gemnasium] [![Code Climate](http://img.shields.io/codeclimate/github/codeforamerica/citygram.svg)][codeclimate]

[travis]: https://travis-ci.org/codeforamerica/citygram
[gemnasium]: https://gemnasium.com/codeforamerica/citygram
[codeclimate]: https://codeclimate.com/github/codeforamerica/citygram

__Citygram__ is a geographic notification platform designed to work with open government data. It allows residents to designate area(s) of a city they are interested in and subscribe to one or more topics. When an event for a desired topic occurs in the subscriber's area of interest, a notification (email, SMS, or [webhook]) is delivered. Citygram is a [Code for America] project by the [Charlotte] and [Lexington] teams for the [2014 fellowship].

[webhook]: http://en.wikipedia.org/wiki/Webhook
[Code for America]: https://github.com/codeforamerica
[Charlotte]: http://team-charlotte.tumblr.com/
[Lexington]: http://teambiglex.tumblr.com/
[2014 fellowship]: http://www.codeforamerica.org/geeks/our-geeks/2014-fellows/

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

## Installation and configuration

### Installation

First, follow the instructions to install each of the following:

* [Install Ruby](https://github.com/codeforamerica/howto/blob/master/Ruby.md)
* [Install PostgreSQL and PostGIS](https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md) 
* Install Redis - `brew install redis` on OS X, available from your package manager on Linux or [direct download](http://redis.io/download)

Then, in the command line, run the following to copy the citygram code locally and install all Ruby package dependencies:

```
$ git clone https://github.com/codeforamerica/citygram.git
$ cd citygram
$ bundle install
```

#### Configure Environment

Make sure your PostgreSQL server is running, then in the terminal run:

```
$ cp .env.sample .env
$ rake db:create db:migrate
$ rake db:create db:migrate DATABASE_URL=postgres://localhost/citygram_test
```

### Running Citygram Website and Services

Basic things you'll want to do with your Citygram server:

##### Run the server

To boot up the complete application and run background jobs in development:
```
$ bundle exec foreman start
```

You can then open [http://localhost:5000/](http://localhost:5000/) in your web browser.

#### Acquiring data

When you can run the application, you're capable of getting some example data.

*Before running these commands, ensure foreman is running per the instructions in the previous section!*

```
$ bundle exec rake publishers:download
$ bundle exec rake publishers:update
```

The first command downloads active publishers from Citygram. The second command will update those publishers from open data portals across the country.


##### Send a digest

```
$ rake digests:send
```

##### Send a a weekly Digest

For Heroku Scheduler users, there is a task that can be executed multiple times,
but will only deliver mail on the environment's `DIGEST_DAY`.

```
$ ENV['DIGEST_DAY'] = 'wednesday'
$ rake digests:send_if_digest_day
```

[![Heroku Scheduler](https://cloud.githubusercontent.com/assets/81055/8840908/732942c2-30b5-11e5-8af7-06b9e169d281.png)](https://devcenter.heroku.com/articles/scheduler)


### Developing

As a developer you may want to:

##### Set up a Single City Installation

If you only need to support a single city you can specify the <kbd>ROOT_CITY_TAG</kbd> to bypass the index and load one city.

For example, https://www.citygram.nyc/ is a single city installation with the following environment variable

```
$ ROOT_CITY_TAG=new-york
```

##### Test the code

Run all tests in the `spec/` directory, by running:
```
$ rake
```
