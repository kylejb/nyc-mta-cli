# The Commuter

## DEMO

![The Commuter Demo](demo/Mod1-Project_DEMO-Full_v2.gif)

## SETUP

#### Prerequisites: 
* You will need get [your MTA API KEY](https://datamine.mta.info/) to access departure times
* Ruby 2.7.1 or later as well as the gems listed in Gemfile (run `bundle`)

#### Seeding Database:

1. Run `rake db:migrate` to initialize a local copy of my database model on your computer.

2. Run `rake db:seed` to populate your database with TrainStation data; feel free to change line 13 and 14 in db/seeds.rb, if you do not want my sample data.

## Planned Changes

The _SETUP_ will be refactored and automated/optimized in later versions.

* Short term: additional code refactoring

* Long term: _TBD_

---

## Author

- Kyle Burda ([@kylejb](https://github.com/kylejb))
