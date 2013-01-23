use Rack::Auth::Basic do |username, password|
  [username, password] == [USER['name'], USER['password']]
end

get '/' do
  redirect to '/schedules'
end
