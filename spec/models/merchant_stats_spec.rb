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
    @umerch2 = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfaust1@naver.com",password:"ZCoxai", enabled: true, role:1)

    @i8 = @umerch.items.create(item_name: "Four Roses Single Barrel",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h2d/h6e/11152774365214.png",current_price: 43.0,inventory: 30, description:"Dried spice, pear, cocoa, vanilla & maple syrup. Hints of ripe plum & cherries, robust, full body, mellow. Smooth & delicately long.",enabled: true)
    @i15 = @umerch.items.create(item_name: "Jack Daniels Single Barrel Heritage Barrel",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Jack-Daniels-Heritage.png",current_price: 65.0,inventory: 33, description:"Tennessee- A delicious and complex whiskey. Barreled in heavy-toast barrels and bottled at 100 proof. Notes of baking spices, vanilla, and toasted oak. Long, lingering finish.",enabled: true)
    @i24 = @umerch.items.create(item_name: "Little Book Chapter 2 'Noe Simple Task'",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Little-Book-Noe-Simple.png",current_price: 100.0,inventory: 40, description:"Blend of whiskeys from Jim Beam and Canadian distilleries owned by Beam Suntory",enabled: true)
    @i12 = @umerch2.items.create(item_name: "Pappy Van Winkle 23 Year",image_url: "https://www.buffalotracedistillery.com/sites/default/files/PVW-23yr.png",current_price: 270.0,inventory: 35, description:"Early aromas of caramel and cream with soft notes of oak, nuts and leather. Features a sweet taste composed of vanilla, maple and honey joined by complimentary flavors of citrus and spice. Has a long lasting oaky finish, along with many of the early flavors.",enabled: true)
    @i13 = @umerch2.items.create(item_name: "Wild Turkey 101",image_url: "https://www.totalwine.com/dynamic/490x/media/sys_master/twmmedia/hc4/h94/9923597533214.png",current_price: 19.0,inventory: 28, description:"Corn and waxy honey aroma, with a deep chunk of earthy rye behind it. Not overly sweet in the mouth. This is lean, almost leathery, and leads to a long, strong finish, where a spike of mint appears. Definitely more than the barshot Bourbon it's often relegated to.",enabled: true)


    @o1 = @u16.orders.create(status: 2)
    @o2 = @u16.orders.create(status: 2)
    @o3 = @u17.orders.create(status: 2)
    @o4 = @u17.orders.create(status: 2)
    @o5 = @u17.orders.create(status: 2)
    @o6 = @u18.orders.create(status: 2)
    @o7 = @u19.orders.create(status: 2)
    @o8 = @u20.orders.create(status: 2)
    @o9 = @u21.orders.create(status: 2)
    @o10 = @u21.orders.create(status: 2)
    @o11 = @u21.orders.create(status: 2)
    @o12 = @u21.orders.create(status: 2)


    @oi1 = OrderItem.create(order_id: @o1.id,item_id: @i8.id, quantity: 4,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 11:50:20",updated_at: "2018-04-13 13:08:43")
    @oi2 = OrderItem.create(order_id: @o2.id,item_id: @i15.id, quantity: 6,fulfilled: true,order_price: 10.0,created_at: "2018-04-06 19:07:44",updated_at: "2018-04-17 00:06:32")
    @oi3 = OrderItem.create(order_id: @o3.id,item_id: @i24.id, quantity: 8,fulfilled: true,order_price: 10.0,created_at: "2018-04-08 22:14:08",updated_at: "2018-04-14 02:03:32")
    @oi4 = OrderItem.create(order_id: @o4.id,item_id: @i8.id, quantity: 10,fulfilled: true,order_price: 10.0,created_at: "2018-04-10 09:04:53",updated_at: "2018-04-12 00:25:16")
    @oi5 = OrderItem.create(order_id: @o5.id,item_id: @i15.id, quantity: 12,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 20:03:19",updated_at: "2018-04-14 11:15:44")
    @oi6 = OrderItem.create(order_id: @o6.id,item_id: @i24.id, quantity: 14,fulfilled: true,order_price: 10.0,created_at: "2018-04-04 10:42:04",updated_at: "2018-04-17 16:22:35")
    @oi7 = OrderItem.create(order_id: @o7.id,item_id: @i8.id, quantity: 16,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 17:57:49",updated_at: "2018-04-14 08:56:26")
    @oi8 = OrderItem.create(order_id: @o8.id,item_id: @i15.id, quantity: 18,fulfilled: true,order_price: 10.0,created_at: "2018-04-09 14:24:00",updated_at: "2018-04-15 03:51:26")
    @oi9 = OrderItem.create(order_id: @o9.id,item_id: @i24.id, quantity: 20,fulfilled: true,order_price: 10.0,created_at: "2018-04-07 23:06:46",updated_at: "2018-04-18 21:14:44")
    @oi10 = OrderItem.create(order_id: @o10.id,item_id: @i12.id, quantity: 16,fulfilled: true,order_price: 10.0,created_at: "2018-04-05 22:49:21",updated_at: "2018-04-18 16:09:57")
    @oi11 = OrderItem.create(order_id: @o11.id,item_id: @i12.id, quantity: 17,fulfilled: true,order_price: 10.0,created_at: "2018-04-04 18:58:29",updated_at: "2018-04-17 15:35:00")
    @oi12 = OrderItem.create(order_id: @o12.id,item_id: @i13.id, quantity: 200,fulfilled: true,order_price: 10.0,created_at: "2018-04-09 05:42:01",updated_at: "2018-04-14 07:19:36")
    @oi13 = OrderItem.create(order_id: @o12.id,item_id: @i12.id, quantity: 200,fulfilled: true,order_price: 10.0,created_at: "2018-04-07 17:46:56",updated_at: "2018-04-12 06:24:31")
  end

  describe 'self.top_three_states' do
    it 'lists top 3 states by quantity sold' do
      expect(User.top_three_states(@umerch).first.state).to eq("California")
      expect(User.top_three_states(@umerch).first.sum).to eq(34)
      expect(User.top_three_states(@umerch).second.state).to eq("Nevada")
      expect(User.top_three_states(@umerch).second.sum).to eq(30)
      expect(User.top_three_states(@umerch).third.state).to eq("Pennsylvania")
      expect(User.top_three_states(@umerch).third.sum).to eq(18)
    end
  end

  describe "self.top_three_states_array" do
    it "turns the top 3 states into an array with state/quantity" do
      expected = [["California", 34],["Nevada",30],["Pennsylvania",18]]
      expect(User.top_three_states_array(@umerch)).to eq(expected)
    end
  end

  describe 'self.top_three_city_states' do
    it 'lists top 3 city, states by quantity sold' do
      expect(User.top_three_city_states(@umerch).first.citystate).to eq("Fresno, Nevada")
      expect(User.top_three_city_states(@umerch).first.sum).to eq(30)
      expect(User.top_three_city_states(@umerch).second.citystate).to eq("Miami, California")
      expect(User.top_three_city_states(@umerch).second.sum).to eq(20)
      expect(User.top_three_city_states(@umerch).third.citystate).to eq("Harrisburg, Pennsylvania")
      expect(User.top_three_city_states(@umerch).third.sum).to eq(18)
    end
  end

  describe "self.top_three_city_states_array" do
    it "turns the top 3 states into an array with state/quantity" do
      expected = [["Fresno, Nevada", 30],["Miami, California",20],["Harrisburg, Pennsylvania",18]]
      expect(User.top_three_city_states_array(@umerch)).to eq(expected)
    end
  end


  describe "self.top_three_merchants_overall" do
    it "lists top 3 merchants by quantity * price" do
      expect(User.top_three_merchants_overall.first.name).to eq(@umerch2.name)
      expect(User.top_three_merchants_overall.first.sum).to eq(4330)
      expect(User.top_three_merchants_overall.second.name).to eq(@umerch.name)
      expect(User.top_three_merchants_overall.second.sum).to eq(1080)
    end
  end


  describe "self.three_fastest" do
    it "lists top 3 merchants by speed of fulfillment" do
      expect(User.three_fastest.first.name).to eq(@umerch.name)
      expect(User.three_fastest.first.avg).to eq("7 days 24:05:59.444444")
      expect(User.three_fastest.second.name).to eq(@umerch2.name)
      expect(User.three_fastest.second.avg).to eq("8 days 19:03:04.25")
    end
  end

  describe "self.three_slowest" do
    it "lists bottom 3 merchants by speed of fulfillment or lack thereof" do
      expect(User.three_slowest.first.name).to eq(@umerch2.name)
      expect(User.three_slowest.first.avg).to eq("8 days 19:03:04.25")
      expect(User.three_slowest.second.name).to eq(@umerch.name)
      expect(User.three_slowest.second.avg).to eq("7 days 24:05:59.444444")
    end
  end

  describe "self.top_three_states_overall" do
    it "lists top 3 states overall by order count" do
      expect(User.top_three_states_overall.first.state).to eq("California")
      expect(User.top_three_states_overall.first.count).to eq(6)
      expect(User.top_three_states_overall.second.state).to eq("Nevada")
      expect(User.top_three_states_overall.second.count).to eq(3)
      expect(User.top_three_states_overall.third.state).to eq("Missouri")
      expect(User.top_three_states_overall.third.count).to eq(2)
    end
  end


  describe "self.top_three_city_states_overall" do
    it "lists top 3 city,states overall by order count" do
      expect(User.top_three_city_states_overall.first.citystate).to eq("Miami, California")
      expect(User.top_three_city_states_overall.first.count).to eq(5)
      expect(User.top_three_city_states_overall.second.citystate).to eq("Fresno, Nevada")
      expect(User.top_three_city_states_overall.second.count).to eq(3)
      expect(User.top_three_city_states_overall.third.citystate).to eq("Saint Louis, Missouri")
      expect(User.top_three_city_states_overall.third.count).to eq(2)
    end
  end

  describe "self.three_biggest_orders" do
    it "lists top 3 biggest orders" do
      expect(User.three_biggest_orders.first.id).to eq(@o12.id)
      expect(User.three_biggest_orders.first.sum).to eq(400)
      expect(User.three_biggest_orders.second.id).to eq(@o9.id)
      expect(User.three_biggest_orders.second.sum).to eq(20)
      expect(User.three_biggest_orders.third.id).to eq(@o8.id)
      expect(User.three_biggest_orders.third.sum).to eq(18)
    end
  end

  describe ".total_sales_array" do
    it "makes an array of merchant names and their total revenue" do
      expected = [["#{@umerch2.name}",66710],["#{@umerch.name}",7830]]
      expect(User.total_sales_array).to eq(expected)
    end
  end

  describe ".top_merchants_array" do
    it "makes an array of top merchant names and their total revenue" do
      expected = [["#{@umerch2.name}",66710],["#{@umerch.name}",7830]]
      expect(User.top_merchants_array).to eq(expected)
    end
  end

  describe ".biggest_orders_array" do
    it "makes an array of the biggest orders by id" do
      expected = [["#{@o12.id}",400],["#{@o9.id}",20],["#{@o8.id}",18]]
      expect(User.biggest_orders_array).to eq(expected)
    end
  end

  describe "self.fastest_array" do
    it "lists top 3 merchants by speed of fulfillment" do
      expected = [["#{@umerch.name}","7 days 24:05:59.444444"],["#{@umerch2.name}","8 days 19:03:04.25"]]
      expect(User.fastest_array).to eq(expected)
    end
  end

  describe "self.slowest_array" do
    it "lists bottom 3 merchants by speed of fulfillment or lack thereof" do
      expected = [["#{@umerch2.name}","8 days 19:03:04.25"],["#{@umerch.name}","7 days 24:05:59.444444"]]
      expect(User.slowest_array).to eq(expected)
    end
  end

  describe "self.states_overall_array" do
    it "creates an array of the overall top states" do
      expected = [["California",6],["Nevada",3],["Missouri",2]]
      expect(User.states_overall_array).to eq(expected)
    end
  end

  describe "self.cities_overall_array" do
    it "creates an array of the overall top cities" do
      expected = [["Miami, California",5],["Fresno, Nevada",3],["Saint Louis, Missouri",2]]
      expect(User.cities_overall_array).to eq(expected)
    end
  end
end
