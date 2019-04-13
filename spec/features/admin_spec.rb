require "rails_helper"

RSpec.describe "As an admin who is logged in" do
  before :each do
    @uadmin = User.create!(name: "Darnell Topliss",street_address: "02 Monument Street",city: "Lincoln",state: "Nebraska",zip_code: "68515",email_address: "dtopliss6@unicef.org",password:"usJn1CuUB", enabled: true, role:2, slug: "dtopliss6-unicef-org")

    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1, slug: "ochadburn0-washingtonpost-com")
    @umerch2 = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfaust1@naver.com",password:"ZCoxai", enabled: true, role:1, slug: "rfaust1-naver-com")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@umerch2)

    @u1 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: true, role:0, slug: "cchilver2-mysql-com")
    @u4 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:0, slug: "scromett3-github-io")
    @u8 = User.create!(name: "Tonya Baldock",street_address: "5 Bellgrove Crossing",city: "Yakima",state: "Washington",zip_code: "98902",email_address: "tbaldock7@wikia.com",password:"GN2dr6VfS", enabled: true, role:0, slug: "tbaldock7-wikia-com")

    @i39 = @umerch.items.create(item_name: "Tovolo King Cube Tray",image_url: "https://www.totalwine.com/dynamic/490x/media/sys_master/twmmedia/hc7/h7c/11374503362590.png",current_price: 9.0,inventory: 40, description:"Ice cubes, squared. These larger-than-normal ice cubes add a little special pizazz to a drink on the rocks. The silicone tray makes for easy removal of the cubes so that they won't shatter or crack. Cheers!",enabled: true)
    @i44 = @umerch.items.create(item_name: "Etched Globe Whiskey Glasses",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h2b/hde/8876890587166.png",current_price: 30.0,inventory: 44, description:"A sure conversation starter, the decorative etching of the world map brings a new spin on serving spirits.",enabled: true)
    @i23 = @umerch2.items.create(item_name: "Belle Meade Cask Strength Reserve",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Belle-Meade-Cask-Strength.png",current_price: 60.0,inventory: 36, description:"Tennessee- A blend of single barrel bourbons making each batch slightly different. Aged for 7-11 years. Flavors of vanilla, caramel, spice, and stone fruits. Try it neat or on the rocks.",enabled: true)

    @o39 = @u4.orders.create(status: 2)
    @o49 = @u8.orders.create(status: 0)

    @oi171 = OrderItem.create(order_id: @o39.id,item_id: @i39.id, quantity: 7,fulfilled: true,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
    @oi172 = OrderItem.create(order_id: @o39.id,item_id: @i44.id, quantity: 7,fulfilled: true,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
    @oi214 = OrderItem.create(order_id: @o49.id,item_id: @i44.id, quantity: 2,fulfilled: false,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-04-15 04:26:51")
    @oi215 = OrderItem.create(order_id: @o49.id,item_id: @i23.id, quantity: 2,fulfilled: false,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-04-15 04:26:51")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@uadmin)
  end

  describe "on all pages" do
    it "should have Users in the nav-bar" do
      visit root_path
      click_link "Users"
      expect(current_path).to eq(admin_users_path)
    end
  end

  describe "when I visit merchant show but role is user" do
    it "should redirect me to /users/:id" do
      visit admin_merchant_path(@u1)
      expect(current_path).to eq(admin_user_path(@u1))
    end
  end

  describe "on admin users index page" do
    it "should show all the users in the system" do
      visit admin_users_path
      expect(page).to have_css(".merchant-card", count: 3)
      within first ".merchant-card" do
        expect(page).to have_link(@u1.name)
        expect(page).to have_content("Registered: #{@u1.created_at}")
        expect(page).to have_link("Upgrade to Merchant")
      end
      within ".merchants-container" do
        expect(page).to_not have_content("Darnell Topliss")
        expect(page).to_not have_content("Ondrea Chadburn")
      end
    end

    it "should link to user show pages via their name" do
      visit admin_users_path
      click_link "Con Chilver"
      expect(current_path).to eq(admin_user_path(@u1))
    end
    it "should link to user show pages via their name" do
      visit admin_user_path(@umerch)
      expect(current_path).to eq(admin_merchant_path(@umerch))
    end

    it "should upgrade the user to a merchant and they can no longer be seen" do
      visit admin_users_path
      within first ".merchant-card" do
        click_link "Upgrade to Merchant"
        expect(current_path).to eq(admin_merchant_path(@u1))
      end
      expect(page).to have_content("#{@u1.name} has been upgraded to a merchant")
      visit admin_users_path
      within ".merchants-container" do
        expect(page).to_not have_content(@u1.name)
      end
    end
  end

  describe "admin merchants index" do
    describe "clicking on a merchant name from merchants index page" do
      it "should take me to the admin merchant show page" do
        visit admin_merchants_path
        within first ".merchant-card" do
          expect(page).to have_link("Disable")
          click_link "Ondrea Chadburn"
          expect(current_path).to eq admin_merchant_path(@umerch)
        end
      end
    end

    describe 'click link to enable/disable item' do
      it 'should disable/enable merchant' do
        visit admin_merchants_path
        within first ".merchant-card" do
          click_link 'Disable Merchant'
          expect(current_path).to eq(admin_merchants_path)
        end
        expect(page).to have_link('Enable Merchant')
        click_link 'Enable Merchant'
        expect(page).to_not have_link('Enable Merchant')
      end
    end
  end

  describe "on a merchants show page" do
    it "should show me the mechant's profile info" do
      visit admin_merchant_path(@umerch)
      expect(page).to have_content("Name: #{@umerch.name}")
      expect(page).to have_content("Street Address: #{@umerch.street_address}")
      expect(page).to have_content("City: #{@umerch.city}")
      expect(page).to have_content("State: #{@umerch.state}")
      expect(page).to have_content("Zip Code: #{@umerch.zip_code}")
      expect(page).to have_content("Email Address: #{@umerch.email_address}")
      expect(page).to_not have_content("#{@umerch.password}")
    end

    it "should show me the merchant's statistics" do
      visit admin_merchant_path(@umerch)
      expect(page).to have_css(".statistics")
    end

    it "should show me the merchant's unfulfilled orders" do
      visit admin_merchant_path(@umerch)
      expect(page).to have_css(".order-card", count: 1)
      within first ".order-card" do
        expect(page).to have_content("Order ID: #{@o49.id}")
        expect(page).to have_content("Ordered On: #{@o49.created_at}")
        expect(page).to have_content("Quantity: #{@umerch.my_item_count(@o49)}")
        expect(page).to have_content("Total Price: $#{@umerch.my_total(@o49)}")
      end
    end


    it "should show me the downgrade to user button" do
      visit admin_merchant_path(@umerch)
      expect(page).to have_link('Downgrade to User')
    end

    it "should redirect me to user profile page" do
      visit admin_merchant_path(@umerch)
      click_link "Downgrade to User"
      expect(current_path).to eq(admin_user_path(@umerch))
    end
  end


  describe 'when I visit my dashboard page' do
    it "I see all orders in the system" do
      visit admin_dashboard_path(@uadmin)
      within first ".admin-order-card" do
        expect(page).to have_content("Order ID: #{@o49.id}")
        expect(page).to have_link("#{@u8.name}")
        expect(page).to have_content("status: #{@o49.status}")
      end

      within all(".admin-order-card").last do
      expect(page).to have_content("Order ID: #{@o39.id}")
      expect(page).to have_link("#{@u4.name}")
      expect(page).to have_content("status: #{@o39.status}")
      end
    end

    it "it should have a link that ships packaged orders" do
      @o49.update!(status: 1)

      visit admin_dashboard_path(@uadmin)

      within first ".admin-order-card" do
        expect(page).to have_link("Ship Order")
        click_link("Ship Order")
      end
      expect(current_path).to eq(admin_dashboard_path(@uadmin))

      visit admin_dashboard_path(@uadmin)
      expect(page).to_not have_link("Ship Order")
      expect(page).to_not have_content("packaged")
      expect(@u8.orders.first.status).to eq("shipped")
    end

    it "I can click the user name to go to a admin view of user profile" do
      visit admin_dashboard_path(@uadmin)
      click_link "#{@u8.name}"
      expect(current_path).to eq(admin_user_path(@u8))
    end
  end

  describe 'merchant and user show URIs now contain slugs rather than ids' do
    it 'check user show link' do
      visit admin_dashboard_path(@uadmin)
      click_link "#{@u8.name}"
      expect(current_path).to eq("/admin/users/#{@u8.slug}")
    end

    it 'check merchant show link' do
      visit admin_merchants_path
      click_link "#{@umerch.name}"
      expect(current_path).to eq("/admin/merchants/#{@umerch.slug}")
    end
  end

end
