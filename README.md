# The Commuter

## DEMO

![The Commuter Demo](demo/Mod1-Project_DEMO-Full_v2.gif)

## SETUP

#### Prerequisites:

- You will need get [your MTA API KEY](https://datamine.mta.info/) to access departure times.
- Ruby 3.0.0 or later as well as the gems listed in Gemfile (run `bundle install`).
- Bundler v2+.

#### Installation Instructions:

Both the installation and usage of this application requires a command line interface (e.g., Terminal or iTerm2 for macOSX users).

1. Run `git clone https://github.com/kylejb/nyc-mta-station-arrival-feed.git` in the directory/folder of your choice and `cd nyc-mta-station-arrival-feed/` once the download is complete.

2. You should now be in the root directory of the project. Type in `ls` and hit enter. You are in the right place, if you see "bin", "config", "db", "demo", "lib", "README", etc.

###### From the root directory of the project (see Step 2), the following commands must be inputted as written:

3. Run `rake db:migrate` to initialize a local copy of my database model on your computer.

4. Run `rake db:seed` to populate your database with TrainStation data; uncomment and modify [line 15 in db/seeds.rb](db/seeds.rb), if you want to initialize database with the username and password of your choice.

   1. It's okay to re-run `rake db:seed` if you decide to initialize the database with your credentials later.

5. Finally, `ruby bin/run.rb` to run the application. Enjoy!

---

## Author

- Kyle Burda ([@kylejb](https://github.com/kylejb))
