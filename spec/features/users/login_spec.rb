require 'rails_helper'

RSpec.describe 'Login Page Workflow' do
  it 'can log in as a registered user with valid credentials' do
    user = User.create!(name: "Jeremy", role: 0,
                      street_address: "1331 17th St",
                      city: "Denver",
                      state: "CO",
                      zip_code: 80202,
                      email_address: "Jeremy@test_user.com",
                      password: "test",
                      enabled: true,
                      slug: "Jeremy-test_user-com")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in "email_address", with: "Jeremy@test_user.com"
    fill_in "password", with: "test"

    click_on "Log Me In"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("You are now logged in")
  end

  it "can log in as an admin" do
    user = User.create!(name: "Jeremy", role: 2,
                      street_address: "1331 17th St",
                      city: "Denver",
                      state: "CO",
                      zip_code: 80202,
                      email_address: "Jeremy@test_user.com",
                      password: "test",
                      enabled: true,
                      slug: "Jeremy-test_user-com")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in "email_address", with: "Jeremy@test_user.com"
    fill_in "password", with: "test"

    click_on "Log Me In"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("You are now logged in")

  end

  it "can log in as a merchant" do
    user = User.create!(name: "Jeremy", role: 1,
                      street_address: "1331 17th St",
                      city: "Denver",
                      state: "CO",
                      zip_code: 80202,
                      email_address: "Jeremy@test_user.com",
                      password: "test",
                      enabled: true,
                      slug: "Jeremy-test_user-com")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in "email_address", with: "Jeremy@test_user.com"
    fill_in "password", with: "test"

    click_on "Log Me In"

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("You are now logged in")

  end

  describe 'sad path' do
    it 'cannot log in with incorrect credentials' do
      user = User.create!(name: "Jeremy", role: 0,
                        street_address: "1331 17th St",
                        city: "Denver",
                        state: "CO",
                        zip_code: 80202,
                        email_address: "Jeremy@test_user.com",
                        password: "test",
                        enabled: true,
                        slug: "Jeremy-test_user-com")

      visit login_path

      fill_in "email_address", with: user.email_address
      fill_in "password", with: "wrong"

      click_on "Log Me In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Incorrect email and/or password")

      #submitting an empty form
      click_on "Log Me In"

      expect(page).to have_content("Incorrect email and/or password")


      fill_in "email_address", with: "wrong"
      fill_in "password", with: user.password

      click_on "Log Me In"

      expect(page).to have_content("Incorrect email and/or password")
    end

    it 'will redirect a user of any role who is already logged in to the right path' do
      user = User.create!(name: "Jeremy", role: 0,
                        street_address: "1331 17th St",
                        city: "Denver",
                        state: "CO",
                        zip_code: 80202,
                        email_address: "Jeremy@test_user.com",
                        password: "test",
                        enabled: true,
                        slug: "Jeremy-test_user-com")

      visit login_path

      expect(page).to_not have_content("You are already logged in.")

      fill_in "email_address", with: "Jeremy@test_user.com"
      fill_in "password", with: "test"

      click_button "Log Me In"

      expect(current_path).to eq(profile_path)

      visit login_path

      expect(page).to have_content("You are already logged in.")
      expect(current_path).to eq(profile_path)

      #as a merchant
      user.update!(role: 1)

      visit login_path

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("You are already logged in.")

      #as an admin
      user.update!(role: 2)

      visit login_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content("You are already logged in.")
    end
    it 'cannot login if merchant is disabled' do
      user = User.create!(name: "Test", role: 1,
                        street_address: "1331 17th St",
                        city: "Denver",
                        state: "CO",
                        zip_code: 80202,
                        email_address: "test@test_user.com",
                        password: "test",
                        enabled: false,
                        slug: "Jeremy-test_user-com")
      visit login_path
      fill_in "email_address", with: "test@test_user.com"
      fill_in "password", with: "test"
      click_button "Log Me In"
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your account is disabled")
    end
  end
end
