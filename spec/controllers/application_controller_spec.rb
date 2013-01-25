require_relative '../spec_helper'

describe 'ApplicationController' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should be true" do
    t = true
    t.should be_true
    t.should_not be_nil
  end

  it "should fail without authentication" do
    get '/schedules'
    last_response.status.should == 401
  end
end
