require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'yaml'
require 'inifile'
require 'fileutils'
require 'erb'
require './app/helpers/application_helper.rb'
require File.join(File.dirname(__FILE__), 'lib/x_log.rb')

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
end

use Rack::Auth::Basic do |username, password|
  [username, password] == [USER['name'], USER['password']]
end

before /\/schedules\/(create|update)/ do
  FileUtils.cp SCHEDULE_PATH, SCHEDULE_PATH.gsub(/\.ini/, '.ini_backup')
  params["schedule"].each { |k ,v| params["schedule"][k] = v.sort.join(",") if v.is_a? Array}
  if params["schedule"]["Frequence"] == 'interval'
    params['schedule']['ExecuteDate'], params['schedule']['ExecuteTime'] = '', ''
  else
    params['schedule']['IntervalTime'], params['schedule']['IntervalUnit'] = '', ''
    params['schedule']['ExecuteDate'] = '' if params["schedule"]['Frequence'] == 'daily'
  end
end

get '/clients' do
  @sections = IniFile.load(INI_PATH).to_h
  erb :'clients/index'
end

get '/' do
  redirect to '/schedules'
end
# REVIEW
post '/clients/update' do
  FileUtils.cp INI_PATH, INI_PATH.gsub(/.ini/, '.ini_backup')
  FileUtils.cp SCHEDULE_PATH, SCHEDULE_PATH.gsub(/\.ini/, '.ini_backup')
  ini_file = IniFile.new(nil, filename: INI_PATH)
  schedules = IniFile.load(SCHEDULE_PATH)
  begin
    ini_file.sections.each {|s| ini_file.delete_section s}
    params['sections'].each do |k, v|
      section_title = v['new_title']
      if v['new_title'] != v['old_title']
        schedules.each do |section, parameter, value|
          if parameter == "ClientID" && value.split(',').include?(v['old_title'])
            schedules[section][parameter] = value.gsub(/\b#{v['old_title']}\b/, v['new_title'])
          end 
        end
      end
      ini_file[section_title] = v.reject {|k, v| k =~ /new_title|old_title/}
    end
    ini_file.save and schedules.save
    FileUtils.touch LOCK_FILE
    redirect '/clients', :success => "Clients updated successfully"
  rescue
    FileUtils.cp INI_PATH.gsub(/.ini/, '.ini_backup'), INI_PATH
    FileUtils.cp SCHEDULE_PATH.gsub(/\.ini/, '.ini_backup'), SCHEDULE_PATH
    redirect '/clients', :error => "Failed to update, nothing changed"
  end
end

get '/clients/new' do
  erb :'clients/new'
end

post '/clients/create' do
  FileUtils.cp INI_PATH, INI_PATH.gsub(/.ini/, '.ini_backup')
  begin
    ini_file = IniFile.load(INI_PATH)
    ini_file[params['section_title']] = params['section']
    ini_file.save
    FileUtils.touch LOCK_FILE
    redirect '/clients', :success => "Client #{params['section_title']} has been successfully created"
  rescue
    FileUtils.cp INI_PATH.gsub(/.ini/, '.ini_backup'), INI_PATH
    redirect '/clients', :error => "Failed to create, nothing changed"
  end
end

post '/clients/delete' do
  ini_file = IniFile.load(INI_PATH)
  ini_file.delete_section params["title"]
  ini_file.save
  FileUtils.touch LOCK_FILE
end

# REVIEW
get '/logs' do
  ini_file = IniFile.load(INI_PATH)
  @clients = ini_file.sections
  datestamp = Time.now.strftime("%Y-%m-%d")
  if params[:submit] == 'filter' && params[:date] =~ /\d{4}-\d{2}-\d{2}/
    datestamp = params[:date]
  end
  @filter_params = {:date => datestamp, :status => (params[:status] || "all"), :client => (params[:client] || "all")}
  log_file = File.join(LOG_PATH_PREFIX, "monitor_Transfer_#{datestamp.gsub(/\D/,'')}.log")
  if File.exist? log_file
    @logs = XLog::Log.parse(log_file, @filter_params)
  else
    @error_info = "Log: #{log_file} not found"
  end
  erb :'logs/index'
end

get '/schedules' do
  @schedules = IniFile.load(SCHEDULE_PATH).to_h
  erb :'schedules/index'
end

get '/schedules/new' do
  client_file = IniFile.load(INI_PATH)
  @clients = client_file.sections
  @schedule = {}
  erb :'schedules/new'
end

post '/schedules/create' do
  begin
    schedules = IniFile.load(SCHEDULE_PATH)
    id = (schedules.sections.map{|e|e.to_i}.max || 0) + 1
    schedules[id] = params["schedule"]
    schedules.save
    FileUtils.touch LOCK_FILE
    redirect '/schedules', :success => "Schedule has been successfully created"
  rescue
    FileUtils.cp SCHEDULE_PATH.gsub(/\.ini/, '.ini_backup'), SCHEDULE_PATH
    redirect '/schedules', :error => 'Failed to create, nothing changed.'
  end
end

post '/schedules/delete' do
  schedules = IniFile.load(SCHEDULE_PATH)
  schedules.delete_section(params[:id])
  if schedules.save
    FileUtils.touch LOCK_FILE
    redirect '/schedules', :success => "Schedule has been successfully destroyed"
  end
end

get '/schedules/:id/edit' do
  client_file = IniFile.load(INI_PATH)
  @clients = client_file.sections
  @schedule = IniFile.load(SCHEDULE_PATH)[params[:id]]
  @schedule_id = params[:id]
  erb :'schedules/edit'
end

post '/schedules/update' do
  begin
    schedules = IniFile.load(SCHEDULE_PATH)
    schedules[params[:id]] = params["schedule"]
    schedules.save
    FileUtils.touch LOCK_FILE
    redirect '/schedules', :success => "Schedule has been successfully update"
  rescue
    FileUtils.cp SCHEDULE_PATH.gsub(/\.ini/, '.ini_backup'), SCHEDULE_PATH
    redirect '/schedules', :error => 'Failed to update, nothing changed.'   
  end
end
