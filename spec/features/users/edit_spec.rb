require 'rails_helper'

RSpec.describe 'As a registered user' do
  before :each do
    @user = User.create!(name: "Jeremy", role: 0,
                      street_address: "1331 17th St",
                      city: "Denver",
                      state: "CO",
                      zip_code: 80202,
                      email_address: "Jeremy@test_user.com",
                      password: "password",
                      enabled: true,
                      slug: "Jeremy-test_user-com")

  end
  it "I can edit my profile information" do
    visit root_path

    click_link "Log In"

    fill_in "email_address", with: "#{@user.email_address}"
    fill_in "password", with: "#{@user.password}"

    click_button "Log Me In"

    click_link "Edit Profile"

    expect(current_path).to eq(edit_user_path(@user))
    fill_in "Email address", with: "changeo@changed_address.com"

    click_button "Update Account"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("changeo@changed_address.com")
  end

  it 'throws error when any validations fail' do
    visit root_path
    click_link "Log In"

    fill_in "email_address", with: "#{@user.email_address}"
    fill_in "password", with: "#{@user.password}"

    click_button "Log Me In"

    click_link "Edit Profile"

    expect(current_path).to eq(edit_user_path(@user))
    fill_in "Email address", with: "tester@test.com"
    fill_in "Password", with: "pass"
    fill_in "Confirmation Password", with: "wrong"

    click_on "Update Account"
    expect(current_path).to eq(profile_path)
    expect(page).to have_content("error prohibited")

  end

end
