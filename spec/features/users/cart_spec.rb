require "rails_helper"

RSpec.describe "User's cart abilities", type: :feature do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1, slug: "ochadburn0-washingtonpost-com")
    @uadmin = User.create(name: "Raff Faust",street_address: "066 Debs Place",city: "El Paso",state: "Texas",zip_code: "79936",email_address: "rfaust1@naver.com",password:"ZCoxai", enabled: true, role:1, slug: "rfaust1-naver-com")
    @u1 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: true, role:0, slug: "cchilver2-mysql-com")

    @i1 = @umerch.items.create(item_name: "W.L. Weller Special Reserve",image_url: "http://www.buffalotracedistillery.com/sites/default/files/weller%20special%20reserve%20brand%20page%5B1%5D.png",current_price: 20.0,inventory: 4, description:"A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",enabled: true, slug: "w-l-weller-special-reserve")

    @i2 = @umerch.items.create(item_name: "W.L. Weller C.Y.P.B.",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",current_price: 35.0,inventory: 30, description:"A light aroma with citrus and oak on the nose. The palate is well rounded and balanced, with a medium-long finish and hints of vanilla.",enabled: false, slug: "w-l-weller-c-y-p-b")
  end

  describe "As a visitor or regular user" do
    describe "from the item show page" do
      it "can add an item to my cart" do
        visit login_path
        fill_in "email_address", with: @u1.email_address
        fill_in "password", with: @u1.password
        click_on "Log Me In"

        visit item_path(@i1)
        expect(page).to have_content("My Cart: 0")
        click_button "Add to Cart"
        expect(current_path).to eq items_path
        expect(page).to have_content("You now have 1 #{@i1.item_name} in your cart.") #change to session number

        expect(page).to have_content("My Cart: 1")
      end
    end

    describe 'A visitor or regular user can view their cart' do
      it 'with items in the cart' do

      visit item_path(@i1)
      click_button "Add to Cart"
      visit item_path(@i1)
      click_button "Add to Cart"

      visit cart_path
        within first ".cart-card" do
        expect(page).to have_content("W.L. Weller Special Reserve")
        expect(page).to have_css("img[src*='#{@i1.image_url}']")
        expect(page).to have_content("Ondrea Chadburn")
        expect(page).to have_content("20.0")
        expect(page).to have_content("2")
        expect(page).to have_content("40.0")
        end
      end

      it 'with no items in the cart' do
        visit cart_path
        expect(page).to have_content("Your Cart is empty!")
        expect(page).to_not have_content("Empty my cart")
      end
    end

    describe 'A user with items in the cart' do
      it 'can empty the cart' do
        visit item_path(@i1)
        click_button "Add to Cart"
        visit item_path(@i1)
        click_button "Add to Cart"
        visit item_path(@i2)
        click_button "Add to Cart"

        expect(page).to have_content("My Cart: 3")
        visit cart_path

        click_link "Empty my cart"
        expect(page).to have_content("My Cart: 0")

        expect(current_path).to eq(cart_path)
        expect(page).to have_content("Your Cart is empty!")
      end
    end

    describe 'A user with items in the cart' do
      it 'can delete an item' do
        visit item_path(@i1)
        click_button "Add to Cart"
        visit item_path(@i1)
        click_button "Add to Cart"

        visit cart_path
        expect(page).to have_content("W.L. Weller Special Reserve")
        click_link 'Remove Item'
        expect(current_path).to eq(cart_path)
        expect(page).to_not have_content("W.L. Weller Special Reserve")
      end

      it 'can incrementally add/remove items to quantity' do
        visit item_path(@i2)
        click_button "Add to Cart"

        visit cart_path
        within first ".cart-card" do
          expect(page).to have_content("Quantity: 1")
          select "30", from: :quantity
          click_on 'Update Quantity'
        end
        expect(current_path).to eq(cart_path)
        within first ".cart-card" do
          expect(page).to have_content("Quantity: 30")
        end
      end

      it 'removes item when quantity changed to 0' do
        visit item_path(@i2)
        click_button "Add to Cart"

        visit cart_path
        within first ".cart-card" do
          expect(page).to have_content("Quantity: 1")
          select "0", from: :quantity
          click_on 'Update Quantity'
        end
        expect(current_path).to eq(cart_path)
        expect(page).to_not have_content("W.L. Weller Special Reserve")
      end

      it 'asks visitor to login or register to check out' do
        visit item_path(@i2)
        click_button "Add to Cart"
        visit cart_path

        within ".cart-container" do
          expect(page).to have_link('Register')
          expect(page).to have_link('Log In')
          expect(page).to_not have_button('Check Out')
        end
      end

      it 'does not ask user to login or register to check out' do
        visit login_path
        fill_in "email_address", with: @u1.email_address
        fill_in "password", with: @u1.password
        click_on "Log Me In"

        visit item_path(@i2)
        click_button "Add to Cart"
        visit cart_path

        within ".cart-container" do
          expect(page).to_not have_link('Register')
          expect(page).to_not have_link('Log In')
        end
      end

      it 'does allows a user to check out' do
        visit login_path
        fill_in "email_address", with: @u1.email_address
        fill_in "password", with: @u1.password
        click_on "Log Me In"

        visit item_path(@i2)
        click_button "Add to Cart"
        visit cart_path

        within ".cart-container" do
          expect(page).to have_button('Check Out')
        end

        click_button 'Check Out'

        expect(current_path).to eq(profile_orders_path)
        expect(page).to have_content("Your order was successfully created!")

        within ".navbar" do
          expect(page).to have_content("My Cart: 0")
        end

        within ".order-card" do
          expect(page).to have_content("pending")
          expect(page).to have_content("Item Quantity: 1")
          expect(page).to have_content("Total: $35")
        end

      end
    end
  end
end
