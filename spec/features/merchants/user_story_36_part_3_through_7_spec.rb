require 'rails_helper'

RSpec.describe 'when we visit a merchant show page' do
  before :each do
    @u16 = User.create(name: "Madelon Hicken",street_address: "3830 Becker Trail",city: "Saint Louis",state: "Missouri",zip_code: "63116",email_address: "mhickenf@unesco.org",password:"q9qDA9PA", enabled: true, role:0)
    @u17 = User.create(name: "Leanor Dencs",street_address: "1 Cody Lane",city: "Fresno",state: "Nevada",zip_code: "89502",email_address: "ldencsg@mozilla.com",password:"KPI7nrZoA", enabled: true, role:0)
    @u18 = User.create(name: "Aleta Gemnett",street_address: "7 Norway Maple Avenue",city: "Fresno",state: "California",zip_code: "93722",email_address: "agemnetth@bloglines.com",password:"mFvAX7nP", enabled: true, role:0)
    @u19 = User.create(name: "Vere Armin",street_address: "8954 Northridge Circle",city: "Minneapolis",state: "Minnesota",zip_code: "55407",email_address: "varmini@a8.net",password:"sBAIMwr", enabled: true, role:0)
    @u20 = User.create(name: "Shawn Goosnell",street_address: "06366 Veith Avenue",city: "Harrisburg",state: "Pennsylvania",zip_code: "17104",email_address: "sgoosnellj@hubpages.com",password:"BiGRBWYs", enabled: true, role:0)
    @u21 = User.create(name: "Abby Stedell",street_address: "0383 Shasta Circle",city: "Miami",state: "California",zip_code: "33127",email_address: "astedellk@yelp.com",password:"zVstAHzK", enabled: true, role:0)

    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)

    @i8 = @umerch.items.create(item_name: "Four Roses Single Barrel",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h2d/h6e/11152774365214.png",current_price: 43.0,inventory: 30, description:"Dried spice, pear, cocoa, vanilla & maple syrup. Hints of ripe plum & cherries, robust, full body, mellow. Smooth & delicately long.",enabled: true)
    @i15 = @umerch.items.create(item_name: "Jack Daniels Single Barrel Heritage Barrel",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Jack-Daniels-Heritage.png",current_price: 65.0,inventory: 33, description:"Tennessee- A delicious and complex whiskey. Barreled in heavy-toast barrels and bottled at 100 proof. Notes of baking spices, vanilla, and toasted oak. Long, lingering finish.",enabled: true)
    @i24 = @umerch.items.create(item_name: "Little Book Chapter 2 'Noe Simple Task'",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Little-Book-Noe-Simple.png",current_price: 100.0,inventory: 40, description:"Blend of whiskeys from Jim Beam and Canadian distilleries owned by Beam Suntory",enabled: true)

    @o1 = @u16.orders.create(status: 2)
    @o2 = @u16.orders.create(status: 2)
    @o3 = @u17.orders.create(status: 2)
    @o4 = @u17.orders.create(status: 2)
    @o5 = @u17.orders.create(status: 2)
    @o6 = @u18.orders.create(status: 2)
    @o7 = @u19.orders.create(status: 2)
    @o8 = @u20.orders.create(status: 2)
    @o9 = @u21.orders.create(status: 2)

    @oi1 = OrderItem.create(order_id: @o1.id,item_id: @i8.id, quantity: 4,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi2 = OrderItem.create(order_id: @o2.id,item_id: @i15.id, quantity: 6,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi3 = OrderItem.create(order_id: @o3.id,item_id: @i24.id, quantity: 8,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi4 = OrderItem.create(order_id: @o4.id,item_id: @i8.id, quantity: 10,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi5 = OrderItem.create(order_id: @o5.id,item_id: @i15.id, quantity: 12,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi6 = OrderItem.create(order_id: @o6.id,item_id: @i24.id, quantity: 14,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi7 = OrderItem.create(order_id: @o7.id,item_id: @i8.id, quantity: 16,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi8 = OrderItem.create(order_id: @o8.id,item_id: @i15.id, quantity: 18,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi9 = OrderItem.create(order_id: @o9.id,item_id: @i24.id, quantity: 20,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@umerch)
    visit dashboard_path
  end

 # now in pie charts
  # it 'shows us top 3 states where items were shipped with quantities' do
  #   within ".statistics" do
  #     expect(page).to have_content("Top 3 States - California: 34 Nevada: 30 Pennsylvania: 18")
  #   end
  # end
  #
  # it 'shows us top 3 city,ST wher items were shipped with quantities' do
  #   within ".statistics" do
  #     expect(page).to have_content("Top 3 Cities - Fresno, Nevada: 30 Miami, California: 20 Harrisburg, Pennsylvania: 18")
  #   end
  # end

  it 'shows us top users' do
    within ".statistics" do
      expect(page).to have_content("Top Customer (orders): Leanor Dencs - 3")
      expect(page).to have_content("Top Customer (items): Leanor Dencs - 30")
      expect(page).to have_content("Top Customers (revenue): Leanor Dencs - $300.00 Abby Stedell - $200.00 Shawn Goosnell - $180.00")
    end
  end

end
