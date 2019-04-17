require "rails_helper"

RSpec.describe "Merchant Show Page" do
  before :each do
    @u7 = User.create!(name: "Darnell Topliss",street_address: "02 Monument Street",city: "Lincoln",state: "Nebraska",zip_code: "68515",email_address: "dtopliss6@unicef.org",password:"usJn1CuUB", enabled: true, role:1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@u7)

    @u34 = User.create(name: "Jazmin Frederick",street_address: "59 Victoria Lane",city: "Atlanta",state: "Georgia",zip_code: "30318",email_address: "jfrederickx@t-online.de",password:"FZbJe0", enabled: true, role:0)
    @u20 = User.create(name: "Shawn Goosnell",street_address: "06366 Veith Avenue",city: "Harrisburg",state: "Pennsylvania",zip_code: "17104",email_address: "sgoosnellj@hubpages.com",password:"BiGRBWYs", enabled: true, role:0)

    @i19 = @u7.items.create(item_name: "Armorik Double Maturation",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Armorik-Double.png",current_price: 60.0,inventory: 33, description:"French Single malt that takes a slightly different route than it's Irish and Scottish cousins and uses new charred oak barrels instead of the more common ex-bourbon barrels.",enabled: true)
    @i23 = @u7.items.create(item_name: "Belle Meade Cask Strength Reserve",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Belle-Meade-Cask-Strength.png",current_price: 60.0,inventory: 36, description:"Tennessee- A blend of single barrel bourbons making each batch slightly different. Aged for 7-11 years. Flavors of vanilla, caramel, spice, and stone fruits. Try it neat or on the rocks.",enabled: true)
    @i39 = @u7.items.create(item_name: "Tovolo King Cube Tray",image_url: "https://www.totalwine.com/dynamic/490x/media/sys_master/twmmedia/hc7/h7c/11374503362590.png",current_price: 9.0,inventory: 40, description:"Ice cubes, squared. These larger-than-normal ice cubes add a little special pizazz to a drink on the rocks. The silicone tray makes for easy removal of the cubes so that they won't shatter or crack. Cheers!",enabled: true)
    @i44 = @u7.items.create(item_name: "Etched Globe Whiskey Glasses",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h2b/hde/8876890587166.png",current_price: 30.0,inventory: 44, description:"A sure conversation starter, the decorative etching of the world map brings a new spin on serving spirits.",enabled: true)
    @i40 = @u7.items.create(item_name: "Tovolo Clear Sphere Ice Mold",image_url: "https://www.totalwine.com/dynamic/490x/media/sys_master/twmmedia/hda/h26/11374525349918.png",current_price: 30.0,inventory: 47, description:"Finally, an easy method for making clear ice! Perfectly insulated system creates a controlled environment where the oxygen is pushed into the bottom tray, leaving you with 4 crystal-clear ice cubes. Ultra-slow melting Clear Ice won't dilute your favorite spirits or cocktails.",enabled: true)
    @i41 = @u7.items.create(item_name: "Tovolo Clear King Cube Ice Mold",image_url: "https://www.totalwine.com/dynamic/490x/media/sys_master/twmmedia/hc1/h58/11374525382686.png",current_price: 30.0,inventory: 27, description:"Finally, an easy method for making clear ice! Perfectly insulated system creates a controlled environment where the oxygen is pushed into the bottom tray, leaving you with 4 crystal-clear ice spheres. Ultra-slow melting Clear Ice won't dilute your favorite spirits or cocktails.",enabled: true)
    @i50 = @u7.items.create(item_name: "Medieval Collectables Satin Finish Flask",image_url: "http://www.medievalcollectibles.com/images/Product/large/CG8931.png",current_price: 10.0,inventory: 37, description:"The stainless steel flask is both classic and classy with a funnel for easy filling to enjoy wherever the party may go.",enabled: true)

    @o39 = @u34.orders.create(status: 2)
    @o49 = @u20.orders.create(status: 2)


    @oi171 = OrderItem.create(order_id: @o39.id,item_id: @i19.id, quantity: 7,fulfilled: false,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
    @oi214 = OrderItem.create(order_id: @o49.id,item_id: @i23.id, quantity: 2,fulfilled: true,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-04-15 04:26:51")
    @oi200 = OrderItem.create(order_id: @o39.id,item_id: @i39.id, quantity: 1,fulfilled: true,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
    @oi201 = OrderItem.create(order_id: @o49.id,item_id: @i44.id, quantity: 3,fulfilled: true,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-04-15 04:26:51")
    @oi203 = OrderItem.create(order_id: @o39.id,item_id: @i40.id, quantity: 5,fulfilled: true,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
    @oi204 = OrderItem.create(order_id: @o49.id,item_id: @i41.id, quantity: 9,fulfilled: true,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-04-15 04:26:51")
    @oi205 = OrderItem.create(order_id: @o49.id,item_id: @i50.id, quantity: 4,fulfilled: true,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-04-15 04:26:51")
  end

  context 'merchant visiting dashboard' do
    it 'shows profile information' do
      visit dashboard_path
      expect(page).to have_content("Name: #{@u7.name}")
      expect(page).to have_content("Street Address: #{@u7.street_address}")
      expect(page).to have_content("City: #{@u7.city}")
      expect(page).to have_content("State: #{@u7.state}")
      expect(page).to have_content("Zip Code: #{@u7.zip_code}")
      expect(page).to have_content("Email Address: #{@u7.email_address}")
      expect(page).to_not have_content("#{@u7.password}")
    end


    it "should have a link to the merchant's coupon page" do
      visit dashboard_path
      expect(page).to have_link("My Coupons")
      click_link ("My Coupons")
      expect(current_path).to eq(dashboard_coupons_path)
    end


    it 'show unfulfilled order information' do
      visit dashboard_path
      expect(page).to have_content("Order ID: #{@o39.id}")
      expect(page).to have_content("Ordered On: #{@o39.created_at}")
      expect(page).to have_content("Quantity: 13")
      expect(page).to have_content("Total Price: 689.0")
    end

    it 'does not show fulfilled order information' do
      visit dashboard_path
      expect(page).to_not have_content("Order ID: #{@oi214.order_id}")
      expect(page).to_not have_content("Ordered On: #{@oi214.created_at}")
      expect(page).to_not have_content("Quantity: #{@oi214.quantity}")
      expect(page).to_not have_content("Total Price: #{@oi214.order_price}")
    end

    it 'order id is a link to order show page' do
      visit dashboard_path
      click_link "Order ID: #{@oi171.order_id}"
      expect(current_path).to eq(dashboard_order_path(@oi171.order_id))
    end
  end

  context 'click on Items Index link' do
    it 'should redirect to dashboard/items' do
      visit dashboard_path
      within first ".order-card" do
        click_link "My Items"
      end
      expect(current_path).to eq(dashboard_items_path)
    end
  end

  context 'in the statistics area' do
    it 'shows top 5 items sold by quantity and the quantity sold' do
      visit dashboard_path

      within '.statistics' do
        expected = "#{@i41.item_name} - #{@i41.quantity_sold} bought\n#{@i40.item_name} - #{@i40.quantity_sold} bought\n#{@i50.item_name} - #{@i50.quantity_sold} bought\n#{@i44.item_name} - #{@i44.quantity_sold} bought\n#{@i23.item_name} - #{@i23.quantity_sold} bought"
        expect(page).to have_content(expected)
      end
    end

    it "shows the percentage and total quantity of items I've sold" do
      visit dashboard_path
      within '.statistics' do
        expect(page).to have_content("Total Items Sold: 24")
        expect(page).to have_content("Percentage of Inventory Sold: 8.33%")
      end
    end

    it "shows charts for the statistics" do
      visit merchants_path
      expect(page).to have_css("#chart-1")
      expect(page).to have_css("#chart-2")
      expect(page).to have_css("#chart-3")
      expect(page).to have_css("#chart-4")
      expect(page).to have_css("#chart-5")
    end
  end

end
