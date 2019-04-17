require "rails_helper"

RSpec.describe "cart and coupon methods", type: :feature do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)
    @umerch2 = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfaust1@naver.com",password:"ZCoxai", enabled: true, role:1)
    @uadmin = User.create(name: "Willard Dutnall",street_address: "77991 Eliot Avenue",city: "Houston",state: "Texas",zip_code: "77036",email_address: "wdutnalla@flickr.com",password:"zI1wi9APT", enabled: true, role:2)

    @u1 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: true, role:0)

    @i1 = @umerch.items.create(item_name: "W.L. Weller Special Reserve",image_url: "http://www.buffalotracedistillery.com/sites/default/files/weller%20special%20reserve%20brand%20page%5B1%5D.png",current_price: 20.0,inventory: 4, description:"A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",enabled: true)

    @i2 = @umerch.items.create(item_name: "W.L. Weller C.Y.P.B.",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",current_price: 35.0,inventory: 30, description:"A light aroma with citrus and oak on the nose. The palate is well rounded and balanced, with a medium-long finish and hints of vanilla.",enabled: true)

    @i19 = @umerch2.items.create(item_name: "Armorik Double Maturation",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Armorik-Double.png",current_price: 60.0,inventory: 33, description:"French Single malt that takes a slightly different route than it's Irish and Scottish cousins and uses new charred oak barrels instead of the more common ex-bourbon barrels.",enabled: true)

    @i23 = @umerch2.items.create(item_name: "Belle Meade Cask Strength Reserve",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Belle-Meade-Cask-Strength.png",current_price: 60.0,inventory: 36, description:"Tennessee- A blend of single barrel bourbons making each batch slightly different. Aged for 7-11 years. Flavors of vanilla, caramel, spice, and stone fruits. Try it neat or on the rocks.",enabled: true)

    @c1 = @umerch.coupons.create(name: "WEEKEND15OFF",	discount: 0, amount: 15, active: 0)
    @c2 = @umerch.coupons.create(name: "SUMMER20OFF",	discount: 0, amount: 20, active: 0)
    @c3 = @umerch2.coupons.create(name: "HOLIDAY15PERCENT",	discount: 1, amount: 15, active: 1)
    @c4 = @umerch2.coupons.create(name: "15PERCENT",	discount: 1, amount: 15, active: 0)
    @c5 = @umerch2.coupons.create(name: "150OFF",	discount: 0, amount: 150, active: 0)
    @u1.coupons << @c1

    visit login_path
    fill_in "email_address", with: @u1.email_address
    fill_in "password", with: @u1.password
    click_on "Log Me In"

    visit item_path(@i2)
    click_button "Add to Cart"
    visit item_path(@i23)
    click_button "Add to Cart"
  end

  describe "coupon functionality" do
    it "does not allow a visitor to add a coupon" do
      click_link "Log Out"
      visit item_path(@i2)
      click_button "Add to Cart"
      visit cart_path
      within ".cart-container" do
        expect(page).to_not have_button('Add Coupon')
      end
    end

    it "allows a logged-in user to add a coupon" do
      visit cart_path
      within ".cart-container" do
        fill_in "Coupon code", with: "example"
        expect(page).to have_button('Add Coupon')
      end
    end

    it "does not allow a non-existing coupon to be used" do
      visit cart_path
      within ".cart-container" do
        fill_in "Coupon code", with: "example"
        click_button "Add Coupon"
      end
      expect(page).to have_content("Coupon does not exist")
    end

    it "does not allow a disabled coupon to be used" do
      visit cart_path
      within ".cart-container" do
        fill_in "Coupon code", with: "#{@c3.name}"
        click_button "Add Coupon"
      end
      expect(page).to have_content("Coupon does not exist")
    end

    it "does not allow an already used coupon to be used" do
      visit cart_path
      within ".cart-container" do
        fill_in "Coupon code", with: "#{@c1.name}"
        click_button "Add Coupon"
      end
      expect(page).to have_content("Coupon has already been used")
    end

    it "displays a discounted total if user uses a coupon" do
      visit cart_path

      within ".cart-container" do
        fill_in "Coupon code", with: "#{@c2.name}"
        click_button "Add Coupon"
      end
      expect(page).to have_content("#{@c2.name} has been added")
      expect(page).to have_content("Discount Total: $75.00")

      within ".cart-container" do
        fill_in "Coupon code", with: "#{@c5.name}"
        click_button "Add Coupon"
      end
      expect(page).to have_content("Discount Total: $35.00")
    end

    it "displays a very discounted total if user uses a coupon" do
      visit cart_path

      within ".cart-container" do
        fill_in "Coupon code", with: "#{@c5.name}"
        click_button "Add Coupon"
      end
      expect(page).to have_content("Discount Total: $35.00")
    end
  end
end
