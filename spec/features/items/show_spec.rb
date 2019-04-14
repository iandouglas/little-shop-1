require "rails_helper"

RSpec.describe "Items Show Page" do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1, slug: "ochadburn0-washingtonpost-com")

    @uadmin = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfaust1@naver.com",password:"ZCoxai", enabled: true, role:2, slug: "rfaust1-naver-com")

    @u1 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: true, role:0, slug: "cchilver2-mysql-com")

    @i1 = @umerch.items.create(item_name: "W.L. Weller Special Reserve",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",current_price: 20.0,inventory: 4, description:"A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",enabled: true, slug: "w-l-weller-special-reserve")

    @i2 = @umerch.items.create(item_name: "W.L. Weller C.Y.P.B.",image_url: "http://www.buffalotracedistillery.com/sites/default/files/weller%20special%20reserve%20brand%20page%5B1%5D.png",current_price: 35.0,inventory: 30, description:"A light aroma with citrus and oak on the nose. The palate is well rounded and balanced, with a medium-long finish and hints of vanilla.",enabled: true, slug: "w-l-weller-c-y-p-b")
    #these are necessary to calculate avg_fulfill_time
    @o1 = @u1.orders.create(status: 2)
    @oi171 = OrderItem.create(order_id: @o1.id,item_id: @i1.id, quantity: 7,fulfilled: true,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")

  end


  context "anyone visiting an item show page" do
    it "shows all the information for that item" do
      visit item_path(@i1)
      expect(page).to have_content(@i1.item_name)
      expect(page).to have_content(@i1.description)
      expect(page).to have_css("img[src*='#{@i1.image_url}']")
      expect(page).to have_content("Sold by: #{@i1.merchant_name}")
      expect(page).to have_content("#{@i1.inventory} left in stock")
      expect(page).to have_content("$#{@i1.current_price}")
      avg_fulfill_time = @i1.avg_fulfill_time[0].split(" ")[0,2].join(" ")
      expect(page).to have_content("Usually ships in #{avg_fulfill_time}")
      visit item_path(@i2)
      expect(page).to have_content("no shipments yet")
    end
  end

  context "as a visitor" do
    it "has a link to add this item to my cart" do
      visit item_path(@i1)
      expect(page).to have_selector(:link_or_button, "Add to Cart")
    end
  end

  context "as a regular user" do
    it "has a link to add this item to my cart" do
      visit root_path
      click_link "Log In"
      fill_in "Email", with: @u1.email_address
      fill_in "Password", with: @u1.password
      click_button "Log Me In"
      visit item_path(@i1)
      expect(page).to have_button("Add to Cart")
    end
  end

  context "as a merchant or admin" do
    it "does not have a link to add item to my cart" do
      visit root_path
      click_link "Log In"
      fill_in "Email", with: @umerch.email_address
      fill_in "Password", with: @umerch.password
      click_button "Log Me In"
      visit item_path(@i1)
      expect(page).to_not have_link("Add to Cart")
    end

    it "does not have a link to add item to my cart" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@uadmin)

      visit item_path(@i1)
      expect(page).to_not have_button("Add to Cart")
    end
  end
end
