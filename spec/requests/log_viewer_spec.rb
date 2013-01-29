require_relative '../spec_helper'

describe 'LogViewer' do

  before { page.driver.browser.basic_authorize 'thrall', 'password'}

  it "should show log page without entries" do
    visit '/logs'
    page.status_code.should eql 200
    page.should have_selector("h1", :text => "Log Viewer")
    page.should have_selector("div.alert-error", :size => 1)
  end

  it "should show logs" do
    visit '/logs?date=2013-01-25&status=all&client=all&submit=filter'
    page.status_code.should eql 200
    page.should_not have_selector("div.alert-error")
    page.should have_selector("table.table-striped tbody tr", :count => 4)
  end

  it "should show logs only for one client" do
    visit '/logs'
    fill_in 'date', :with => '2013-01-25'
    select 'client1', :from => 'client'
    click_button :submit
    page.should have_selector("table.table-striped tbody tr", :count => 2)
  end

  it "should show logs for one client with failed status" do
    visit '/logs'
    fill_in 'date', :with => '2013-01-25'
    select 'client1', :from => 'client'
    select 'Fail', :from => 'status'
    click_button :submit
    page.should have_selector("table.table-striped tbody tr", :count => 1)
    page.should have_selector("span.label-important", :text => 'fail')
  end
end
