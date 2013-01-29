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

  config.before do
    FileUtils.cp CLIENTS_FILE.gsub(/\.ini$/, '.fixture.ini'), CLIENTS_FILE
    FileUtils.cp SCHEDULES_FILE.gsub(/\.ini$/,'.fixture.ini'), SCHEDULES_FILE
  end
end
