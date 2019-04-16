require 'rails_helper'

RSpec.describe 'rating CRUD' do
  before :each do
    @u4 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:1)
    @u8 = User.create(name: "Tonya Baldock",street_address: "5 Bellgrove Crossing",city: "Yakima",state: "Washington",zip_code: "98902",email_address: "tbaldock7@wikia.com",password:"GN2dr6VfS", enabled: true, role:1)
    @u17 = User.create(name: "Leanor Dencs",street_address: "1 Cody Lane",city: "Reno",state: "Nevada",zip_code: "89502",email_address: "ldencsg@mozilla.com",password:"KPI7nrZoA", enabled: true, role:0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@u17)


    @i1 = @u4.items.create(item_name: "W.L. Weller Special Reserve",image_url: "http://www.buffalotracedistillery.com/sites/default/files/weller%20special%20reserve%20brand%20page%5B1%5D.png", current_price: 20.0,inventory: 4, description:"A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",enabled: true, slug: "w-l-weller-special-reserve")
    @i2 = @u4.items.create(item_name: "W.L. Weller C.Y.P.B.",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png", current_price: 35.0,inventory: 30, description:"A light aroma with citrus and oak on the nose. The palate is well rounded and balanced, with a medium-long finish and hints of vanilla.",enabled: true, slug: "w-l-weller-c-y-p-b")
    @i3 = @u8.items.create(item_name: "Bulleit Bourbon",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h5c/hed/11635356794910.png",current_price: 22.0,inventory: 42, description:"Medium amber in color, with gentle spiciness and sweet oak aromas. Mid-palate is smooth with tones of maple, oak, and nutmeg. Finish is long, dry, and satiny with a light toffee flavor.",enabled: true, slug: "bulleit-bourbon")
    @i4 = @u4.items.create(item_name: "Stagg Jr.",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/hd3/h4f/10678919528478.png",current_price: 40.0,inventory: 30, description:"Rich, sweet, chocolate and brown sugar flavors mingle in perfect balance with the bold rye spiciness. The boundless finish lingers with hints of cherries, cloves and smokiness.",enabled: true, slug: "stagg-jr")
    @i5 = @u8.items.create(item_name: "George T. Stagg",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Antique-GTS_0.png",current_price: 85.0,inventory: 47, description:"Lush toffee sweetness and dark chocolate with hints of vanilla, fudge, nougat and molasses. Underlying notes of dates, tobacco, dark berries, spearmint and a hint of coffee round out the palate.",enabled: true, slug: "george-t-stagg")
    @i6 = @u4.items.create(item_name: "Old Forester 1910 Old Fine Whisky",image_url: "https://static.oldforester.com/app/uploads/2017/04/25181857/1920-2017.png",current_price: 45.0,inventory: 35, description:"A double barreled Bourbon creating a smooth mingling of sweet oatmeal raisin cookie and milk chocolate, caramel corn, and evolving spice that lead into a refined, charred oak finish.",enabled: true, slug: "old-forester-1910-old-fine-whisky")
    @i7 = @u8.items.create(item_name: "Woodford Reserve Kentucky Straight Bourbon",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h57/h8d/11276299108382.png",current_price: 30.0,inventory: 43, description:"Clean, brilliant honey amber. Heavy with rich dried fruit, hints of mint and oranges covered with a dusting of cocoa. Faint vanilla and tobacco spice. Rich, chewy, rounded and smooth, with complex citrus, cinnamon and cocoa. Toffee, caramel, chocolate and spice notes abound. Silky smooth, almost creamy at first with a long, warm satisfying tail.",enabled: true, slug: "woodford-reserve-kentucky-straight-bourbon")

    @o1 = @u17.orders.create(status: 2)
    @o2 = @u17.orders.create(status: 2)
    @o3 = @u17.orders.create(status: 0)

    @oi1 = OrderItem.create(order_id: @o1.id,item_id: @i1.id, quantity: 4,fulfilled: true,order_price: 66.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi2 = OrderItem.create(order_id: @o1.id,item_id: @i2.id, quantity: 4,fulfilled: true,order_price: 57.0,created_at: "2018-04-06 19:07:44",updated_at: "2018-04-17 00:06:32")
    @oi3 = OrderItem.create(order_id: @o2.id,item_id: @i1.id, quantity: 4,fulfilled: true,order_price: 64.0,created_at: "2018-04-08 22:14:08",updated_at: "2018-04-14 02:03:32")
    @oi4 = OrderItem.create(order_id: @o2.id,item_id: @i2.id, quantity: 2,fulfilled: true,order_price: 58.0,created_at: "2018-04-10 09:04:53",updated_at: "2018-04-12 00:25:16")
    @oi5 = OrderItem.create(order_id: @o3.id,item_id: @i1.id, quantity: 6,fulfilled: false,order_price: 44.0,created_at: "2018-04-05 20:03:19",updated_at: "2018-04-14 11:15:44")
    @oi6 = OrderItem.create(order_id: @o3.id,item_id: @i2.id, quantity: 8,fulfilled: false,order_price: 63.0,created_at: "2018-04-04 10:42:04",updated_at: "2018-04-17 16:22:35")
    @oi6 = OrderItem.create(order_id: @o3.id,item_id: @i4.id, quantity: 1,fulfilled: false,order_price: 63.0,created_at: "2018-04-04 10:42:04",updated_at: "2018-04-17 16:22:35")
  end

  it 'lets a user fill out a form to create a new review' do
    visit profile_order_path(@o1)

    within first ".order-item-card" do
      click_link "Leave Review"
    end

    fill_in "Title", with: "It's fine"
    fill_in "Description", with: "It might grow on me"
    fill_in "Rating", with: 3
    click_button "Create Rating"

    expect(current_path).to eq(profile_orders_path)
  end

  it "then shows that review on the item show page" do
    visit profile_order_path(@o1)
    within first ".order-item-card" do
      click_link "Leave Review"
    end
    fill_in "Title", with: "It's fine"
    fill_in "Description", with: "It might grow on me"
    fill_in "Rating", with: 3
    click_button "Create Rating"

    visit item_path(@i1)
    save_and_open_page
    within first ".rating-card" do
      expect(page).to have_content("It's fine")
      expect(page).to have_content("It might grow on me")
      expect(page).to have_content("Rating: 3/5")
    end
  end

end
