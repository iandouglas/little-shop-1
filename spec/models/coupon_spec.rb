require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :discount}
    it {should validate_presence_of :amount}
    it {should validate_presence_of :active}
  end

  describe "relationships" do
    it {should have_many :user_coupons}
    it {should have_many :users}
  end

  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)
    @umerch2 = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfauft1@naver.com",password:"ZCoxai", enabled: true, role:1)

    @u1 = User.create(name: "Jazmin Frederick",street_address: "59 Victoria Lane",city: "Atlanta",state: "Georgia",zip_code: "30318",email_address: "jfrederickx@t-online.de",password:"FZbJe0", enabled: true, role:0)
    @u2 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: false, role:0)
    @u3 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:0)

    @i19 = @umerch.items.create(item_name: "Armorik Double Maturation",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Armorik-Double.png",current_price: 60.0,inventory: 33, description:"French Single malt that takes a slightly different route than it's Irish and Scottish cousins and uses new charred oak barrels instead of the more common ex-bourbon barrels.",enabled: true)
    @i23 = @umerch2.items.create(item_name: "Belle Meade Cask Strength Reserve",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Belle-Meade-Cask-Strength.png",current_price: 60.0,inventory: 36, description:"Tennessee- A blend of single barrel bourbons making each batch slightly different. Aged for 7-11 years. Flavors of vanilla, caramel, spice, and stone fruits. Try it neat or on the rocks.",enabled: true)

    @c1 = @umerch.coupons.create(name: "WEEKEND15OFF",	discount: 0, amount: 15, active: 0)
    @c2 = @umerch.coupons.create(name: "SUMMER20OFF",	discount: 0, amount: 20, active: 0)
    @c3 = @umerch2.coupons.create(name: "HOLIDAY15PERCENT",	discount: 1, amount: 15, active: 1)
    @c4 = @umerch2.coupons.create(name: "15PERCENT",	discount: 1, amount: 15, active: 0)

    @u2.coupons << @c1
    @u1.coupons << @c1


  end

  describe ".customers" do
    it "should list the users who have used this coupon in an order" do
      expect(@c1.customers).to include(@u1)
      expect(@c1.customers).to include(@u2)
      expect(@c2.customers).to eq([])
    end
  end

  describe ".item_list" do
    it "should list the items that this coupon can be used for" do
      expect(@c1.item_list).to eq([@i19])
      expect(@c4.item_list).to eq([@i23])
    end
  end

  describe ".percent_off" do
    it "should return the percent remaining to multiply a price by" do
      expect(@c4.percent_off).to eq(0.85)
    end
  end
end
