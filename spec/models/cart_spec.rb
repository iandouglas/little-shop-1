require "rails_helper"

RSpec.describe Cart do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)

    @item = @umerch.items.create!(
            item_name: "W.L. Weller Special Reserve",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.2e2,
            enabled: true)
    @item2 = @umerch.items.create!(
            item_name: "W.L. Weller Special Reserve",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 15,
            current_price: 0.3e2,
            enabled: true)
    @item3 = @umerch.items.create!(
            item_name: "W.L. Weller Special Reserve",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.25e2,
            enabled: true)

            @d1 = @item2.discounts.create!(percentage: 0.05, min_quantity: 5)
            @d2 = @item2.discounts.create!(percentage: 0.10, min_quantity: 15)
            @d3 = @item2.discounts.create!(percentage: 0.15, min_quantity: 30)

    @cart = Cart.new({
      "#{@item.id}" => 3,
      "#{@item2.id}" => 5,
      "#{@item3.id}" => 2
      })
  end

  describe ".total_count" do
    it "should add up all cart items" do

      expect(@cart.total_count).to eq(10)
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
      expect(@cart.count_of(@item2.id)).to eq(6)
    end
  end

  describe ".subtotal" do
    it "should calculate item quantity times price" do
      expect(@cart.subtotal(@item)).to eq(60.0)
    end
    it "should calculate the price with a discount" do
      expect(@cart.subtotal(@item2)).to eq(142.5)
    end
  end

  describe ".cart_total" do
    it "calculates total cart price" do
      expect(@cart.cart_total).to eq(252.5)
    end
  end
end
