require_relative '../spec_helper'

describe 'ApplicationController' do
  it "should be true" do
    t = true
    t.should be_true
    t.should_not be_nil
  end

  it "should fail without authentication" do
    visit '/schedules'
    page.status_code.should eql 401
  end

  it "should fail with bad credentials" do
    page.driver.browser.basic_authorize 'bad', 'bad'
    visit '/schedules'
    page.status_code.should eql 401
  end

  it "should visit successfully with proper credentials" do
    page.driver.browser.basic_authorize 'thrall', 'password'
    visit '/schedules'
    page.status_code.should eql 200
    page.should have_selector("h1", :text => 'Schedules List' )
  end
end
