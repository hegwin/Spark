# REVIEW
get '/logs' do
  ini_file = IniFile.load(CLIENTS_FILE)
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
