National Day of Civic Hacking 2016
==================================

Summary
-------

Welcome! To get the WHY? and TECH overview, [see the home page ("read me" document) of this repository](https://github.com/codefordurham/citygram). For tech setup, we should have development instances setup on the cloud for you to look at during the hackathon.

Citygram in RTP consists of two github projects:
 * The citygram.org website, which this project is a fork of. It shows the user the website, it polls provider datasets (all the points on the maps), and it sends notifications via SMS or email to users. It is implemented in Ruby, using Sinatra, uses Twilio for SMS. Postgres database is used to store provider data.
 * The RTP [citygram-connector](https://github.com/nigelterry/Citygram-Connector). This projects polls various RTP data portals, scrapes city datasources, and provides data for citygram.org to pull from. It also stores this data to provide more detailed reporting (at the moment, just maps). This is a PHP project, using the YII framework, backing to MongoDB.

See the [dev setup](https://github.com/codefordurham/citygram/blob/master/DAYOFHACKING.md#developer-setup) section.

Tasks
=====

All tasks have been tagged with the skills you would likely need to work on the
task (but feel free to explore any task, or pair up with someone with more
experience).


You can click below and also see all the tasks in waffle to see tasks that are ready for you to tackle:

[![Stories in Ready](https://badge.waffle.io/codefordurham/citygram.svg?label=ready&title=Ready)](http://waffle.io/codefordurham/citygram)

Citizens - Opinions Needed
---------------

These tasks need non-technical, organization, brain-storming, contacting
someone, some copy writing, or just help thinking about the task at hand.

[List of Opinion Tasks](https://github.com/codefordurham/citygram/labels/Citizen%20-%20Opinions%20Needed)


Data Analysis
-------------

Some tasks need people to evaluate or find existing data sources. For these tasks you would: find the datasets, document the data columns, and check that the data is updated regularly.

[List of Data Tasks](https://github.com/dsummersl/citygram/labels/Data%20Analysis)

Frontend
--------

These tasks will require maybe a little HTML, some CSS, a maybe little Javascript.

[List of Frontend Tasks](https://github.com/dsummersl/citygram/labels/Frontend)

Backend
-------

The backend tasks will likely need help from someone with a little Ruby under
their belt.

[List of Backend Tasks](https://github.com/dsummersl/citygram/labels/Backend)

Design
------

These tasks will need someone who can find or make icons, and is familiar with
CSS and hex coloring, or confidence organizing page layout and making a mockup.

[List of Design Tasks](https://github.com/dsummersl/citygram/labels/Design)

Developer Setup
===============

There are two projects that make up RTP Citygram: the website (citygram
project), and the data provider (citygram-connector).

Citygram
--------

Use [these instructions](https://github.com/codefordurham/citygram#installation).

Once the app works, you can prepopulate it with data using [these instructions](https://github.com/codefordurham/citygram#acquiring-data).

Citygram-Connector
------------------

Use [these instructions](https://github.com/dsummersl/Citygram-Connector/tree/vagrantfile#developer-setup-in-vagrant).
