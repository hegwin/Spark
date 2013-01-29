get '/clients' do
  @sections = IniFile.load(CLIENTS_FILE).to_h
  erb :'clients/index'
end

# REVIEW
post '/clients/update' do
  FileUtils.cp CLIENTS_FILE, CLIENTS_FILE.gsub(/.ini/, '.ini_backup')
  FileUtils.cp SCHEDULES_FILE, SCHEDULES_FILE.gsub(/\.ini/, '.ini_backup')
  ini_file = IniFile.new(nil, filename: CLIENTS_FILE)
  schedules = IniFile.load(SCHEDULES_FILE)
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
    FileUtils.cp CLIENTS_FILE.gsub(/.ini/, '.ini_backup'), CLIENTS_FILE
    FileUtils.cp SCHEDULES_FILE.gsub(/\.ini/, '.ini_backup'), SCHEDULES_FILE
    redirect '/clients', :error => "Failed to update, nothing changed"
  end
end

get '/clients/new' do
  erb :'clients/new'
end

post '/clients/create' do
  FileUtils.cp CLIENTS_FILE, CLIENTS_FILE.gsub(/.ini/, '.ini_backup')
  begin
    ini_file = IniFile.load(CLIENTS_FILE)
    ini_file[params['section_title']] = params['section']
    ini_file.save
    FileUtils.touch LOCK_FILE
    redirect '/clients', :success => "Client #{params['section_title']} has been successfully created"
  rescue
    FileUtils.cp CLIENTS_FILE.gsub(/.ini/, '.ini_backup'), CLIENTS_FILE
    redirect '/clients', :error => "Failed to create, nothing changed"
  end
end

post '/clients/delete' do
  ini_file = IniFile.load(CLIENTS_FILE)
  ini_file.delete_section params["title"]
  ini_file.save
  FileUtils.touch LOCK_FILE
end

