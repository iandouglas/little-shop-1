require 'rails_helper'

RSpec.describe 'When I visit the merchant dashboard page' do
  before :each do
    @u7 = User.create!(name: "Darnell Topliss",street_address: "02 Monument Street",city: "Lincoln",state: "Nebraska",zip_code: "68515",email_address: "dtopliss6@unicef.org",password:"usJn1CuUB", enabled: true, role:1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@u7)

    @i19 = @u7.items.create(item_name: "Armorik Double Maturation",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Armorik-Double.png",current_price: 60.0,inventory: 33, description:"French Single malt that takes a slightly different route than it's Irish and Scottish cousins and uses new charred oak barrels instead of the more common ex-bourbon barrels.",enabled: true, slug: "armorik-double-maturation")
    @i23 = @u7.items.create(item_name: "Belle Meade Cask Strength Reserve",image_url: "http://s3.amazonaws.com/mscwordpresscontent/wa/wp-content/uploads/2018/11/Belle-Meade-Cask-Strength.png",current_price: 65.0,inventory: 36, description:"Tennessee- A blend of single barrel bourbons making each batch slightly different. Aged for 7-11 years. Flavors of vanilla, caramel, spice, and stone fruits. Try it neat or on the rocks.",enabled: false, slug: "belle-meade-cask-strength-reserve")

    @u34 = User.create(name: "Jazmin Frederick",street_address: "59 Victoria Lane",city: "Atlanta",state: "Georgia",zip_code: "30318",email_address: "jfrederickx@t-online.de",password:"FZbJe0", enabled: true, role:0)
    @o39 = @u34.orders.create(status: 2)
    @oi171 = OrderItem.create(order_id: @o39.id,item_id: @i19.id, quantity: 7,fulfilled: false,order_price: 53.0,created_at: "2018-04-07 22:05:50",updated_at: "2018-04-17 08:47:14")
  end

  describe 'and click link to view my items' do
    it 'shows me the correct information' do

      visit dashboard_items_path

      expect(page).to have_content(@i19.id)
      expect(page).to have_content("Armorik Double Maturation")
      expect(page).to have_content(60.0)
      expect(page).to have_content(33)

      expect(page).to have_content(@i23.id)
      expect(page).to have_content("Belle Meade Cask Strength Reserve")
      expect(page).to have_content(65.0)
      expect(page).to have_content(36)

      within first ".item-card" do
        expect(page).to have_link('Edit Item')
        expect(page).to have_link('Disable Item')
      end

      within all(".item-card").last do
        expect(page).to have_link('Edit Item')
        expect(page).to have_link('Enable Item')
        expect(page).to have_link('Delete Item')
      end

      expect(page).to have_link('Add New Item')
    end
  end

  describe 'click link to delete item' do
    it 'should delete the item' do
      visit dashboard_items_path
      within all(".item-card").last do
        click_link 'Delete Item'
        expect(current_path).to eq(dashboard_items_path)
      end
      expect(page).to_not have_content(@i23.item_name)
    end
  end

  describe 'click link to enable/disable item' do
    it 'should disable an enabled item' do
      visit dashboard_items_path
      within first ".item-card" do
        click_link 'Disable Item'
        expect(current_path).to eq(dashboard_items_path)
      end
      within first ".item-card" do
        expect(page).to have_link('Enable Item')
      end
    end

    it 'should disable and enabled item' do
      visit dashboard_items_path
      within all(".item-card").last do
        click_link 'Enable Item'
        expect(current_path).to eq(dashboard_items_path)
      end
      within all(".item-card").last do
        expect(page).to have_link('Disable Item')
      end
    end
  end
end
