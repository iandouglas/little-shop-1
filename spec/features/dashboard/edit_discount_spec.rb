require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    @u7 = User.create!(name: "Darnell Topliss",street_address: "02 Monument Street",city: "Lincoln",state: "Nebraska",zip_code: "68515",email_address: "dtopliss6@unicef.org",password:"usJn1CuUB", enabled: true, role:1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@u7)

    @i19 = @u7.items.create(item_name: "Armorik Double Maturation",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Armorik-Double.png",current_price: 60.0,inventory: 33, description:"French Single malt that takes a slightly different route than it's Irish and Scottish cousins and uses new charred oak barrels instead of the more common ex-bourbon barrels.",enabled: true)
    @i23 = @u7.items.create(item_name: "Belle Meade Cask Strength Reserve",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Belle-Meade-Cask-Strength.png",current_price: 65.0,inventory: 36, description:"Tennessee- A blend of single barrel bourbons making each batch slightly different. Aged for 7-11 years. Flavors of vanilla, caramel, spice, and stone fruits. Try it neat or on the rocks.",enabled: false)

    @d1 = @i19.discounts.create!(percentage: 0.05, min_quantity: 5)
    @d2 = @i19.discounts.create!(percentage: 0.10, min_quantity: 15)
    @d3 = @i19.discounts.create!(percentage: 0.15, min_quantity: 30)

    @u34 = User.create(name: "Jazmin Frederick",street_address: "59 Victoria Lane",city: "Atlanta",state: "Georgia",zip_code: "30318",email_address: "jfrederickx@t-online.de",password:"FZbJe0", enabled: true, role:0)
    @o39 = @u34.orders.create(status: 2)
    @oi171 = OrderItem.create(order_id: @o39.id,item_id: @i19.id, quantity: 7,fulfilled: false,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
  end

  context 'when I visit the edit discount page' do
    it "I can edit a discount when I fill in the form and click submit" do
      visit edit_dashboard_discount_path(@d1)

      fill_in "Percentage", with: "10"

      click_button "Update Discount"

      expect(current_path).to eq(dashboard_discounts_path)

      within "#discount-#{@d1.id}" do
        expect(page).to have_content("Discount: 10%")
      end

      visit edit_dashboard_discount_path(@d2)

      fill_in "Threshold quantity", with: "10"

      click_button "Update Discount"
      within "#discount-#{@d2.id}" do
        expect(page).to have_content("Quantity threshold: 10")
      end

      visit edit_dashboard_discount_path(@d3)

      fill_in "Percentage", with: "20"
      fill_in "Threshold quantity", with: "20"

      click_button "Update Discount"

      within "#discount-#{@d3.id}" do
        expect(page).to have_content("Discount: 20%")
        expect(page).to have_content("Quantity threshold: 20")
      end
    end
  end
end
