ENV["RACK_ENV"] = "test"

require_relative "../config/boot.rb"
require 'rspec'
require 'capybara'
require 'capybara/dsl'

set :run, false
set :raise_errors, true
set :logging, false

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
end
