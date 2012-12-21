require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'yaml'
require 'inifile'
require 'fileutils'
require 'erb'
require File.join(File.dirname(__FILE__), 'lib/x_log.rb')

configure do
# loading configures
  configures = YAML.load(File.read(File.dirname(__FILE__) + '/config.yml'))
  INI_PATH = configures["path"]["ini"]
  FileUtlis.touch INI_PATH unless File.exist? INI_PATH
  LOG_PATH_PREFIX = configures["path"]["log_prefix"]
  KEYS = configures["map"]

# settings
  enable :sessions
end
#helpers
helpers do
  def show_flash(flash)
    return if flash.first.nil?
    m = flash.first
    "<div class='alert alert-#{m[0].to_s}'><a class='close' data-dismiss='alert' href='#'>&times;</a>#{m[1]}</div>"
  end

  def generate_options(array)
    array.map {|e| %Q{ <option value='#{e}'>#{e}</option> } }.join
  end

  def show_status(status)
    tag = status=="success" ? 'success' : 'important'
    %Q{ <span class='label label-#{tag}'>#{status}</span>}
  end
end

get '/sections' do
  @sections = IniFile.load(INI_PATH).to_h
  erb :sections
end

get '/' do
  redirect to '/sections'
end
# REVIEW
post '/update' do
  FileUtils.cp INI_PATH, INI_PATH.gsub(/.ini/, '.ini_backup')
  ini_file = IniFile.new(nil, filename: INI_PATH)
  begin
    ini_file.sections.each {|s| ini_file.delete_section s}
    params['sections'].each do |k, v|
      section_title = v['new_title']
      ini_file[section_title] = v.reject {|k, v| k == "new_title"}
    end
    ini_file.save
    redirect '/index', :success => "Sections updated successfully"
  rescue
    FileUtils.cp INI_PATH.gsub("_backup$",''), INI_PATH
    redirect '/index', :error => "Failed to update, nothing changed"
  end
end

get '/new' do
  erb :new
end

post '/create' do
  ini_file = IniFile.load(INI_PATH)
  ini_file[params['section_title']] = params['section']
  if ini_file.save
    redirect '/index', :success => "Section #{params['section_title']} has been created successfully"
  end
end

post '/delete' do
  ini_file = IniFile.load(INI_PATH)
  ini_file.delete_section params["title"]
  ini_file.save
end

# REVIEW
get '/logs' do
  ini_file = IniFile.load(INI_PATH)
  @clients = ini_file.sections
  datestamp = Time.now.strftime("%Y%m%d")
  if params[:submit] == 'filter' && params[:date].gsub(/\D/,'') =~ /\d/
    datestamp = params[:date].gsub(/\D/, '')
  end
  @filter_params = {:date => datestamp, :status => (params[:status] || "all"), :client => (params[:client] || "all")}
  log_file = File.join(LOG_PATH_PREFIX, "monitor_Transfer_#{datestamp}.log")
  if File.exist? log_file
    @logs = XLog::Log.parse(log_file, @filter_params)
  else
    @error_info = "Log: #{log_file} not found"
  end
  erb :logs
end
