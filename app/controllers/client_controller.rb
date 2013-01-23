get '/clients' do
  @sections = IniFile.load(INI_PATH).to_h
  erb :'clients/index'
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

