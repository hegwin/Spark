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
