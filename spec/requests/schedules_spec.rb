require_relative '../spec_helper'

describe 'Schedules', :js => true do

  before do 
    page.driver.browser.basic_authorize 'thrall', 'password'
    visit '/'
  end

  it "should show schedule index page" do
    click_link 'Schedules'
    page.should have_selector("h1", :text => "Schedules List")
    page.should have_selector("table.table-striped tbody tr", :count => 2)
    page.should have_selector("div.form-actions a.btn", :text => "New Schedule")
    page.should have_selector("table.table-striped a.btn-primary", :text =>"Update", :count => 2)
    page.should have_selector("table.table-striped button.btn-danger", :text => "Destroy", :count =>2)
  end

  # FIXME
  it "should create new schedule" do
    click_link 'New Schedule'
    page.should have_selector("h1", :text => "New Schedule")
    wait_until { page.has_selector? "div.form div#execute-time input[name='schedule[ExecuteTime][]']"}
    within(:css, 'div.form') do
      select 'client1', :from => 'schedule[ClientID][]'
      select 'test', :from => 'schedule[FileType][]'
      fill_in 'schedule[ExcuteTime][]', :with => "08:00"
      fill_in 'schedule[StartAt]', :with => "2013-01-01"
      select 'enabled', :from => "schedule[Status]"
    end
    click_button 'Create'
  end

  it "should destroy a schedule" do
    click_button "1"
    page.should have_selector("table.table-striped tbody tr", :count => 1)
    File.should be_exist(LOCK_FILE)
  end

end
