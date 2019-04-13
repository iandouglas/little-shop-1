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

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

  end
  describe 'when I visit my own profile page' do
    it "I can see all my profile data except my password" do

      visit profile_path
      within ".order-card" do
        expect(page).to have_content("Name: #{@user.name}")
        expect(page).to have_content("Street Address: #{@user.street_address}")
        expect(page).to have_content("City: #{@user.city}")
        expect(page).to have_content("State: #{@user.state}")
        expect(page).to have_content("Zip Code: #{@user.zip_code}")
        expect(page).to have_content("Email Address: #{@user.email_address}")
        expect(page).to_not have_content("#{@user.password}")
      end
      expect(page).to have_link("Edit Profile")
    end

    it "has a link to my order page" do
      visit profile_path
      expect(page).to_not have_content("My Orders")
      @user.orders.create!(status: 0)
      visit profile_path
      expect(page).to have_link("My Orders")
    end

  end
end
