require "rails_helper"

RSpec.describe "Items Index Page", type: :feature do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)
    @umerch2 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:1)

    @uadmin = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfaust1@naver.com",password:"ZCoxai", enabled: true, role:2)
    @u1 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: true, role:0)

    @i1 = @umerch.items.create(item_name: "W.L. Weller Special Reserve",image_url: "http://www.buffalotracedistillery.com/sites/default/files/weller%20special%20reserve%20brand%20page%5B1%5D.png",current_price: 20.0,inventory: 4, description:"A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",enabled: true, slug: "w-l-weller-special-reserve")

    @i2 = @umerch2.items.create(item_name: "W.L. Weller C.Y.P.B.",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",current_price: 35.0,inventory: 30, description:"A light aroma with citrus and oak on the nose. The palate is well rounded and balanced, with a medium-long finish and hints of vanilla.",enabled: true, slug: "w-l-weller-c-y-p-b")

    @i3 = @umerch.items.create(item_name: "Bulleit Bourbon",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h5c/hed/11635356794910.png",current_price: 22.0,inventory: 42, description:"Medium amber in color, with gentle spiciness and sweet oak aromas. Mid-palate is smooth with tones of maple, oak, and nutmeg. Finish is long, dry, and satiny with a light toffee flavor.",enabled: false, slug: "bulleit-bourbon")

    @i4 = @umerch2.items.create(item_name: "Stagg Jr.",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/hd3/h4f/10678919528478.png",current_price: 40.0,inventory: 30, description:"Rich, sweet, chocolate and brown sugar flavors mingle in perfect balance with the bold rye spiciness. The boundless finish lingers with hints of cherries, cloves and smokiness.",enabled: false, slug: "stagg-jr")

    @i5 = @umerch.items.create(item_name: "George T. Stagg",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Antique-GTS_0.png",current_price: 85.0,inventory: 47, description:"Lush toffee sweetness and dark chocolate with hints of vanilla, fudge, nougat and molasses. Underlying notes of dates, tobacco, dark berries, spearmint and a hint of coffee round out the palate.",enabled: true, slug: "george-t-stagg")

    @o1 = @u1.orders.create(status: 2)
    @o2 = @u1.orders.create(status: 2)
    @o3 = @u1.orders.create(status: 0)

    @oi1 = OrderItem.create(order_id: @o1.id,item_id: @i1.id, quantity: 4,fulfilled: true,order_price: 66.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi2 = OrderItem.create(order_id: @o1.id,item_id: @i2.id, quantity: 4,fulfilled: true,order_price: 57.0,created_at: "2018-04-06 19:07:44",updated_at: "2018-04-17 00:06:32")
    @oi3 = OrderItem.create(order_id: @o2.id,item_id: @i1.id, quantity: 4,fulfilled: true,order_price: 64.0,created_at: "2018-04-08 22:14:08",updated_at: "2018-04-14 02:03:32")
    @oi4 = OrderItem.create(order_id: @o2.id,item_id: @i2.id, quantity: 2,fulfilled: true,order_price: 58.0,created_at: "2018-04-10 09:04:53",updated_at: "2018-04-12 00:25:16")
    @oi5 = OrderItem.create(order_id: @o3.id,item_id: @i1.id, quantity: 6,fulfilled: false,order_price: 44.0,created_at: "2018-04-05 20:03:19",updated_at: "2018-04-14 11:15:44")
    @oi6 = OrderItem.create(order_id: @o3.id,item_id: @i2.id, quantity: 8,fulfilled: false,order_price: 63.0,created_at: "2018-04-04 10:42:04",updated_at: "2018-04-17 16:22:35")
    @oi7 = OrderItem.create(order_id: @o3.id,item_id: @i3.id, quantity: 800,fulfilled: false,order_price: 63.0,created_at: "2018-04-04 10:42:04",updated_at: "2018-04-17 16:22:35")
    @oi8 = OrderItem.create(order_id: @o3.id,item_id: @i3.id, quantity: 1,fulfilled: false,order_price: 63.0,created_at: "2018-04-04 10:42:04",updated_at: "2018-04-17 16:22:35")
  end

  context "anyone visiting item catalog" do
    it "shows all enabled items and their info to a visitor" do
      visit items_path
      within first ".item-card" do
        expect(page).to have_content(@i5.item_name)
        expect(page).to have_css("img[src*='#{@i5.image_url}']")
        expect(page).to have_content("Merchant: #{@i5.merchant_name}")
        expect(page).to have_content("In Inventory: #{@i5.inventory}")
        expect(page).to have_content("Price: $#{@i5.current_price}")
      end
      expect(page).to have_css(".item-card",count: 3)
      expect(page).to_not have_content(@i3.item_name)
    end

    it "shows all enabled items and their info to an admin" do
      visit root_path
      click_link "Log In"
      fill_in "Email", with: @uadmin.email_address
      fill_in "Password", with: @uadmin.password
      click_button "Log Me In"
      visit items_path
      within first ".item-card" do
        expect(page).to have_content(@i5.item_name)
        expect(page).to have_css("img[src*='#{@i5.image_url}']")
        expect(page).to have_content("Merchant: #{@i5.merchant_name}")
        expect(page).to have_content("In Inventory: #{@i5.inventory}")
        expect(page).to have_content("Price: $#{@i5.current_price}")
      end
      expect(page).to have_css(".item-card",count: 3)
      expect(page).to_not have_content(@i3.item_name)
    end

    it "links item name to item show page" do
      visit items_path
      within first ".item-card" do
        click_link "#{@i5.item_name}"
        expect(current_path).to eq(item_path(@i5))
      end
    end

    it "links item thumbnail to item show page" do
      visit items_path
      within first ".item-card" do
        click_link "image of #{@i5.item_name}"
        expect(current_path).to eq(item_path(@i5))
      end
    end

    it "has a statistics section" do
      visit items_path
      within ".statistics" do
        expect(page).to have_content("Statistics")
      end
    end

    it "shows the five most popular items by total quantity sold" do
      visit items_path
      within ".statistics" do
        expect(page).to have_content("Most Popular Items")
        expect(page).to have_css(".popular", count: 2)
        expect(page).to_not have_content(@i3.item_name)
      end
    end

    it "shows the five least popular items by total quantity sold" do
      visit items_path
      within ".statistics" do
        expect(page).to have_content("Least Popular Items")
        expect(page).to have_content(0)
        expect(page).to have_css(".unpopular", count: 3)
        expect(page).to_not have_content(@i4.item_name)
      end
    end
  end
end
