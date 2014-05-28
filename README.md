citygram
===========

Citygram is a geographically relevant notification platform for cities. It allows citizens to designate geographic area(s) they are interested in, subscribe to specific topics, and and delivers information to citizens when something they’ve subscribed to happens in their area. Citygram is a [Code for America](https://github.com/codeforamerica) project by the Charlotte Team for the 2014 fellowship.

## Why are we doing this?
We believe that there is an opportunity to help citizens better understand what’s going on in their area, when it’s going to happen, and why. By providing timely information to citizens in areas that are relevant to them, the city can be proactive instead of reactive, build trust through transparency, and increase civic engagement across the board.

## What does this do now?
* user can see a gallery of topics to subscribe to 
* user can input their address and designate the area that they are interested in by drawing a polygon
* user can input their phone number and email address
* extract / transform / load publishers' datasets into geoJSON
* a geospatial query system -  a way to find subscribers whose areas of interest intersect with an event. (definition of an “event”: an event exists in a topic area and consists of a title, description of what’s going on, a time component, and a geographic component)

## What will this do in the future?
* user can subscribe to multiple topics
* user can receive SMS or emails based on their subscriptions
* user can choose their city
* user can designate the area that they are interested via radius or past polygon that they've drawn
* user can edit their subscriptions
* user can respond via email / text to provide feedback

## Who is this made by?
- [Danny Whalen](https://github.com/invisiblefunnel)
- [Tiffany Chu](https://github.com/tchu88)
- [Andrew Douglass](https://github.com/ardouglass)

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
