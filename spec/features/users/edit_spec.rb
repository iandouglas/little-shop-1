require 'rails_helper'

RSpec.describe 'As a registered user' do
  before :each do
    @uadmin = User.create!(name: "Darnell Topliss",street_address: "02 Monument Street",city: "Lincoln",state: "Nebraska",zip_code: "68515",email_address: "dtopliss6@unicef.org",password:"usJn1CuUB", enabled: true, role:2, slug: "dtopliss6-unicef-org")

    @user = User.create(name: "Jeremy", role: 0,
                      street_address: "1331 17th St",
                      city: "Denver",
                      state: "CO",
                      zip_code: 80202,
                      email_address: "Jeremy@test_user.com",
                      password: "password",
                      enabled: true,
                      slug: "jeremy-test_user-com")

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

    click_link "Log Out"

    #checking for slug change
    click_link "Log In"

    fill_in "email_address", with: "#{@uadmin.email_address}"
    fill_in "password", with: "#{@uadmin.password}"

    click_button "Log Me In"

    click_link "Users"
    click_link "#{@user.name}"

    expect(current_path).to eq("/admin/users/changeo-changed_address-com")
  end

  it 'the slug will not change if I do not change my email' do
    visit root_path

    click_link "Log In"

    fill_in "email_address", with: "#{@user.email_address}"
    fill_in "password", with: "#{@user.password}"

    click_button "Log Me In"

    click_link "Edit Profile"

    expect(current_path).to eq(edit_user_path(@user))
    fill_in "Name", with: "Matt"

    click_button "Update Account"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Matt")

    click_link "Log Out"

    #checking for slug change
    click_link "Log In"

    fill_in "email_address", with: "#{@uadmin.email_address}"
    fill_in "password", with: "#{@uadmin.password}"

    click_button "Log Me In"

    click_link "Users"
    click_link "Matt"

    expect(current_path).to eq("/admin/users/jeremy-test_user-com")
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
