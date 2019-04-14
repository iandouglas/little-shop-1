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

  describe 'click link to add new item' do
    it 'should go to new form path' do
      visit dashboard_items_path
      click_link "Add New Item"
      expect(current_path).to eq(new_dashboard_item_path)
    end

    it 'should create a new item' do
      visit new_dashboard_item_path
      fill_in "Item name", with: "Test Whiskey"
      fill_in "Description", with: "Test Whiskey description"
      fill_in "Inventory", with: 4
      fill_in "Current price", with: "55.50"

      click_button "Create Item"

      expect(current_path).to eq(dashboard_items_path)

      expect(page).to have_link("Test Whiskey")
      expect(page).to have_content("4")
      expect(page).to have_content("$55.5")
    end

    it 'should not create a new item with bad values' do
      visit new_dashboard_item_path

      click_button "Create Item"

      expect(page).to have_content("Inventory is not a number")
      expect(page).to have_content("Current price is invalid")
      expect(page).to have_content("Current price is not a number")

    end
  end


  describe 'click link to edit item' do
    it 'should go to edit form path' do
      visit dashboard_items_path
      within first ".item-card" do
        click_link "Edit Item"
      end
      expect(current_path).to eq(edit_dashboard_item_path(@i19))
    end

    it 'should update item information' do
      visit edit_dashboard_item_path(@i19)
      fill_in "Description", with: "This is a great whiskey"
      fill_in "Inventory", with: 4

      click_button "Edit Item"

      expect(current_path).to eq(dashboard_items_path)
      within first ".item-card" do
        expect(page).to have_content("4")
      end
    end

    it 'should update item information' do
      visit edit_dashboard_item_path(@i19)
      fill_in "Description", with: "This is a great whiskey"
      fill_in "Inventory", with: "-10"

      click_button "Edit Item"

      expect(page).to have_content("error")
    end
  end

  describe 'slugs should be created with item' do
    it 'creates slug from name if first in database' do
      visit new_dashboard_item_path
      fill_in "Item name", with: "Test Whiskey"
      fill_in "Description", with: "Test Whiskey description"
      fill_in "Inventory", with: 4
      fill_in "Current price", with: "55.50"

      click_button "Create Item"

      expect(current_path).to eq(dashboard_items_path)

      click_link "Test Whiskey"

      expect(current_path).to eq("/items/test-whiskey")
    end
  end

  describe 'slugs sad path' do
    it 'creates slug with a random number if name is duplicate' do

      visit new_dashboard_item_path
      fill_in "Item name", with: "Armorik Double Maturation"
      fill_in "Description", with: "Test Whiskey description"
      fill_in "Inventory", with: 5
      fill_in "Current price", with: "57.50"

      click_button "Create Item"

      within all(".item-card")[1] do
        click_link "Armorik Double Maturation"
      end
      # expect(current_path).to eq("/items/armorik-double-maturation")
    end

    it 'should update item information without changing slug if no name change' do
      visit edit_dashboard_item_path(@i19)
      fill_in "Item name", with: ""
      fill_in "Description", with: "This is a great whiskey"
      fill_in "Inventory", with: 4

      click_button "Edit Item"

      expect(current_path).to eq(dashboard_items_path)
      within first ".item-card" do
        click_link "#{@i19.item_name}"
      end
      expect(current_path).to eq("/items/armorik-double-maturation")
    end
  end

end
