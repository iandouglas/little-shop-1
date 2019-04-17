require "rails_helper"

RSpec.describe User, type: :model do
  describe "Relationships" do
    it {should have_many :items}
    it {should have_many :orders}
    it {should have_many :user_coupons}
    it {should have_many :coupons}
  end

  describe "Class methods" do
    before :each do
      @u1 = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)
      @u2 = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfaust1@naver.com",password:"ZCoxai", enabled: true, role:1)
      @u3 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: false, role:0)
    end


    describe "can return users who are active merchants with" do
      it ".active_merchant" do
        expect(User.active_merchant).to eq([@u1, @u2])
      end
    end
  end

  describe "Merchant methods" do
    before :each do
      @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ofchadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@umerch)

      @u4 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:0)
      @u34 = User.create(name: "Jazmin Frederick",street_address: "59 Victoria Lane",city: "Atlanta",state: "Georgia",zip_code: "30318",email_address: "jfrederickx@t-online.de",password:"FZbJe0", enabled: true, role:0)

      @umerch2 = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfauft1@naver.com",password:"ZCoxai", enabled: true, role:1)

      @i39 = @umerch.items.create(item_name: "Tovolo King Cube Tray",image_url: "https://www.totalwine.com/dynamic/490x/media/sys_master/twmmedia/hc7/h7c/11374503362590.png",current_price: 9.0,inventory: 40, description:"Ice cubes, squared. These larger-than-normal ice cubes add a little special pizazz to a drink on the rocks. The silicone tray makes for easy removal of the cubes so that they won't shatter or crack. Cheers!",enabled: true)
      @i44 = @umerch.items.create(item_name: "Etched Globe Whiskey Glasses",image_url: "https://www.totalwine.com/media/sys_master/twmmedia/h2b/hde/8876890587166.png",current_price: 30.0,inventory: 44, description:"A sure conversation starter, the decorative etching of the world map brings a new spin on serving spirits.",enabled: true)
      @i23 = @umerch2.items.create(item_name: "Belle Meade Cask Strength Reserve",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Belle-Meade-Cask-Strength.png",current_price: 60.0,inventory: 36, description:"Tennessee- A blend of single barrel bourbons making each batch slightly different. Aged for 7-11 years. Flavors of vanilla, caramel, spice, and stone fruits. Try it neat or on the rocks.",enabled: true)

      @c1 = @umerch.coupons.create(name: "WEEKEND15OFF",	discount: 0, amount: 15, active: 0)

      @o39 = @u4.orders.create(status: 2)
      @o49 = @u4.orders.create(status: 0)
      @o59 = @u4.orders.create(status: 0)
      @o60 = @u34.orders.create(status: 2)
      @o61 = @u34.orders.create(status: 2)

      @oi171 = OrderItem.create(order_id: @o39.id,item_id: @i39.id, quantity: 7,fulfilled: true,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
      @oi172 = OrderItem.create(order_id: @o39.id,item_id: @i44.id, quantity: 7,fulfilled: true,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
      @oi214 = OrderItem.create(order_id: @o49.id,item_id: @i44.id, quantity: 2,fulfilled: false,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-05-15 04:26:51")
      @oi215 = OrderItem.create(order_id: @o49.id,item_id: @i23.id, quantity: 2,fulfilled: false,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-05-15 04:26:51")
      @oi275 = OrderItem.create(order_id: @o59.id,item_id: @i23.id, quantity: 2,fulfilled: false,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-07-15 04:26:51")
      @oi275 = OrderItem.create(order_id: @o61.id,item_id: @i39.id, quantity: 2,fulfilled: true,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-07-15 04:26:51")
      @oi275 = OrderItem.create(order_id: @o60.id,item_id: @i44.id, quantity: 2,fulfilled: true,order_price: 48.0,created_at: "2018-04-10 11:06:18",updated_at: "2018-09-15 04:26:51")
    end

    describe ".my_item_count" do
      it "should find the count of the items for a merchant order" do
        expect(@umerch.my_item_count(@o39)).to eq(14)
        expect(@umerch.my_item_count(@o49)).to eq(2)
      end
    end

    describe ".my_total" do
      it "should find the total of the items for a merchant order" do
        expect(@umerch.my_total(@o39)).to eq(742.0)
        expect(@umerch.my_total(@o49)).to eq(96.0)
      end
    end

    describe ".monthly_revenue_array" do
      it "should return an array of the revenue per month" do
        expected = [[17,742],[15,192]]
        expect(@umerch.monthly_revenue_array)
      end
    end

    describe ".daily_revenue_array" do
      it "should return an array of the revenue per month" do
        expected = [[4,742],[7,96],[9,96]]
        expect(@umerch.daily_revenue_array)
      end
    end

    describe ".merchant_pending_orders" do
      it "should list all the orders that include the merchant's items" do
        expect(@umerch.merchant_pending_orders).to eq([@o49])
      end
    end

    describe ".my_used_coupons?" do
      it "should indicate whether or not coupon has been used by user" do
        expect(@u4.my_used_coupons?(@c1.name)).to eq(false)
        @u4.coupons << @c1
        expect(@u4.my_used_coupons?(@c1.name)).to eq(true)
      end
    end

    describe "total_inventory" do
      it "should give the total inventory of a merchant's items" do
        expect(@umerch.total_inventory).to eq(84)
      end
    end

    describe "total_quantity_sold" do
      it "should give the total quantity of a merchant's sold items" do
        expect(@umerch.total_quantity_sold).to eq(18)
      end
    end

    describe "percent_inventory_array" do
      it "should give an array of sold items to unsold items" do
        expected = [["sold", 18],["unsold",66]]
        expect(@umerch.percent_inventory_array).to eq(expected)
      end
    end

    describe "percentage sold" do
      it "should give the percentage of a merchant's inventory sold" do
        expect(@umerch.percentage_sold.round(2)).to eq(17.65)
      end
    end

    describe "top user by orders" do
      it "should give one user name and they will have most orders" do
        expect(User.top_user_by_orders(@umerch).name).to eq(@u34.name)
        expect(User.top_user_by_orders(@umerch).count).to eq(2)
      end
    end

    describe "top user by items" do
      it "returns the top user by quantity of items purchased" do
        expect(User.top_user_by_items(@umerch).name).to eq(@u4.name)
        expect(User.top_user_by_items(@umerch).sum).to eq(14)
      end
    end

    describe "top 3 alcoholics by $$ spent" do
      it 'returns the top 3 users by dollars spent' do
        expect(User.top_users_by_revenue(@umerch).first.name).to eq(@u4.name)
        expect(User.top_users_by_revenue(@umerch).first.sum).to eq(742.0)
      end
    end
  end
end
