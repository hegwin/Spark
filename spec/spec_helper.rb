ENV["RACK_ENV"] = "test"

require_relative "../config/boot.rb"
require 'rspec'
require 'rack/test'

set :run, false
set :raise_errors, true
set :logging, false
