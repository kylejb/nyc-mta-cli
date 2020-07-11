require_relative '../config/environment'
require 'pry'

cli = CommandLineInterface.new
cli.greet
cli.basic_login_and_run