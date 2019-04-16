require 'rails_helper'

RSpec.describe 'logout workflow' do
  before :each do
    @user = User.create!(name: "Jeremy", role: 0,
                      street_address: "1331 17th St",
                      city: "Denver",
                      state: "CO",
                      zip_code: 80202,
                      email_address: "Jeremy@test_user.com",
                      password: "test",
                      enabled: true,
                      slug: "Jeremy-test_user-com")
  end

  it "can logout a registered user" do
    visit root_path

    click_link "Log In"

    fill_in "email_address", with: @user.email_address
    fill_in "password", with: @user.password

    click_button "Log Me In"

    expect(current_path).to eq(profile_path)

    click_link "Log Out"

    expect(current_path).to eq(root_path)

    visit profile_path

    expect(page).to_not have_content(@user.name)
    # expect(page.status_code).to eq(404)
  end
end
