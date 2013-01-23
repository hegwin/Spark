require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'yaml'
require 'inifile'
require 'fileutils'
require 'erb'
Dir.glob "./{lib,app/helpers,app/controllers}/**/*.rb" do |f|
  require f
end

configure do
# loading configures
  configures = YAML.load(File.read(File.dirname(__FILE__) + '/config/config.yml'))
  INI_PATH = configures["path"]["ini"]
  SCHEDULE_PATH = configures["path"]["schedule"]
  LOCK_FILE = configures["path"]["lock_file"]
  LOG_PATH_PREFIX = configures["path"]["log_prefix"]
  CLIENT_KEYS = configures["map"]["client"]
  SCHEDULE_KEYS = configures["map"]["schedule"]

  USER = YAML.load(File.read(File.dirname(__FILE__) + '/config/user.yml'))

  FILE_TYPE= %w[all communication dtp medication pdfs normal].sort
  FREQUENCE = %w[daily weekly monthly once interval]
  WEEKDAYS = {"0"=> "Sunday", "1" => "Monday", "2" => "Tuesday", "3" => "Wednesday", "4" => "Thursday", "5" => "Friday", "6" => "Saturday" }
  STATUS = %w[enabled disabled]
  TIME_UNIT = %w[hour minute]

# settings
  enable :sessions
  set :views, File.dirname(__FILE__) + '/app/views'
end
