require "rails_helper"

RSpec.describe Cart do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)
    @umerch2 = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfauft1@naver.com",password:"ZCoxai", enabled: true, role:1)

    @item = @umerch.items.create!(
            item_name: "W.L. Weller Special Reserve",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.2e2,
            enabled: true)
    @item2 = @umerch.items.create!(
            item_name: "W.L. Weller CYPB",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.3e2,
            enabled: true)
    @item3 = @umerch2.items.create!(
            item_name: "Grand Pappy",
            description: "A sweet nose flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.25e2,
            enabled: true)

    @c1 = @umerch.coupons.create(name: "WEEKEND15OFF",	discount: 0, amount: 15, active: 0)
    @c2 = @umerch.coupons.create(name: "WEEKEND50PERCENT",	discount: 1, amount: 50, active: 0)
    @c4 = @umerch2.coupons.create(name: "100PERCENT",	discount: 1, amount: 1000, active: 0)
    @c5 = @umerch2.coupons.create(name: "150OFF",	discount: 0, amount: 150, active: 0)

    @cart = Cart.new({
      "#{@item.id}" => 3,
      "#{@item2.id}" => 1,
      "#{@item3.id}" => 2
      })
  end

  describe ".total_count" do
    it "should add up all cart items" do

      expect(@cart.total_count).to eq(6)
    end
  end

  describe ".count_of" do
    it "should count a specific item in a cart" do
      expect(@cart.count_of(@item.id)).to eq(3)
    end
  end

  describe ".add_item" do
    it "should add item to my cart" do
      @cart.add_item(@item2.id)
      expect(@cart.count_of(@item2.id)).to eq(2)
    end
  end

  describe ".subtotal" do
    it "should calculate item quantity times price" do
      expect(@cart.subtotal(@item)).to eq(60.0)
    end
  end

  describe ".cart_total" do
    it "calculates total cart price" do
      expect(@cart.cart_total).to eq(140.0)
    end
  end

  describe ".regular_items" do
    it "lists items included on a coupon" do
      expect(@cart.regular_items(@c1).first).to eq(@item3)
    end
  end

  describe ".discount_items" do
    it "lists items included on a coupon" do
      expect(@cart.discount_items(@c1)).to include(@item)
      expect(@cart.discount_items(@c1)).to include(@item2)
    end
  end

  describe ".discount_total" do
    it "calculates the total price with a coupon" do
      expect(@cart.discount_total(@c1)).to eq(125.0)
      expect(@cart.discount_total(@c2)).to eq(95.0)
      expect(@cart.discount_total(@c4)).to eq(90.0)
      expect(@cart.discount_total(@c5)).to eq(90.0)
    end
  end
end
