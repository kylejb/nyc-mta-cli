require_relative 'config/environment'
require 'sinatra/activerecord/rake'
require 'dotenv/tasks'

desc "Starts a console with dotenv"
task console: :dotenv do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

