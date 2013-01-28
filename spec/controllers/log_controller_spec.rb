require_relative '../spec_helper'

describe 'LogController' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before { authorize 'thrall', 'password'}

  it "should show log page without entries" do
    get '/logs'
    page = Nokogiri::HTML.parse(last_response.body)
    page.css("h1").first.text.should == "Log Viewer"
    page.css("div.alert-error").size.should == 1
  end

  it "should show logs" do
    get '/logs?date=2013-01-25&status=all&client=all&submit=filter'
    last_response.should be_ok
    page = Nokogiri::HTML.parse(last_response.body)
    page.css("div.alert-error").should be_empty
    page.css("table.table-striped tbody tr").size.should == 4
    p last_response.class
    p last_response.class.instance_methods(false)
  end
end
