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

### Setup

* Install Redis - `brew install redis`
* [Install PostgreSQL](https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md)
* [Install Ruby](https://github.com/codeforamerica/howto/blob/master/Ruby.md)

In the command line, run the following:

#### Install Dependencies

```
git clone https://github.com/codeforamerica/citygram.git
cd citygram
rbenv install local
brew install postgresql postgis
gem install bundler
bundle install
```

#### Configure Environment

```
cp .env.sample .env
rake db:create db:migrate
rake db:create db:migrate DATABASE_URL=postgres://localhost/citygram_test
```

### Developing

To boot up the complete application and run background jobs in development:

```
bundle exec foreman start -f Procfile.dev
open http://localhost:9292/
```

You can now see your site at

### Testing

Run all tests in the `spec/` directory.

```
rake
```


## Developing with Vagrant

[Vagrant](https://www.vagrantup.com/) is a great tool for spinning up lightweight, reproducible, and portable development environments. It makes it easy to configure a dev environment without worring about conflicts between shared components (i.e. you are developing on two different projects that depend on different versions/configurations of say, a database server).

Once you have installed Vagrant, go to the command line, `cd path/to/citygram` and run `vagrant up`.

### Setting up the vagrant box for the first time

The first time you run `vagrant up`, it might take a while as it will have to download and install Ubuntu on the vagrant box.

Once it finished, "ssh" into your new dev server with `vagrant ssh`.  This will log you into your fresh Ubuntu install as the "vagrant" user. The citygram folder will be mounted at `/vagrant`.

Since this is a fresh install we need to install the software mentioned above: Redis, PostgreSQL/PostGIS, Ruby (and all their dependencies).

First we do all the server-level libraries:

```
$ sudo apt-get -y update
$ sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev curl git-core python-software-properties libxslt1-dev libxml2-dev libmysqlclient-dev libsqlite3-dev libpq-dev nodejs redis-server 

```

Then we install rbenv (to then install Ruby):

```
$ curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
```

After rbenv is installed, it tells you to add the following to the end of your `~/.bashrc` file:

```
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
```

Install Ruby:

```
$ rbenv install `cat .ruby-version`
```

Install PostgreSQL/PostGIS [[1](http://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS21UbuntuPGSQL93Apt)]:

```
$ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt trusty-pgdg main" >> /etc/apt/sources.list'
$ wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
$ sudo apt-get -y update
$ sudo apt-get -y install postgresql-9.4-postgis-2.1 postgresql-contrib
```

Install Bundler and the project's bundle:

```
$ cd /vagrant
$ gem install bundler
$ bundle install
```

Setup your PostgreSQL user:

```
$ cd /vagrant
$ sudo su postrges
$ psql
=# CREATE USER vagrant WITH PASSWORD 'vagrant';
=# ALTER ROLE vagrant SUPERUSER CREATEROLE CREATEDB REPLICATION;
=# CREATE EXTENSION postgis;
=# \q
$ exit
$ echo "DATABASE_URL=postgres://vagrant:vagrant@localhost/citygram_development" >> .env
$ bundle exec rake db:create db:migrate
```

### Starting up the app on the vagrant box

After going through the setup above, to get the app running:

1. login to the vagrant box (`vagrant ssh`)
2. change into the vagrant folder (`cd /vagrant`)
3. start up foreman (`bundle exec foreman start -f Procfile.vagrant`)
4. Open a web browser and go to [http://localhost:9292](http://localhost:9292)
