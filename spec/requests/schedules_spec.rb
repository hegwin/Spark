require_relative '../spec_helper'

describe 'Schedules' do

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

  it "should create new schedule" do
  end

end
