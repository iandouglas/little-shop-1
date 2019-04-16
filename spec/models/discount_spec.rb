require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
    it {should belong_to :item}
  end

  describe 'validations' do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :min_quantity}
    it {should validate_presence_of :item_id}
  end

  before :each do
    @u4 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:1)

    @i1 = @u4.items.create(item_name: "W.L. Weller Special Reserve",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",current_price: 20.0,inventory: 4, description:"A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",enabled: true)

    @d1 = @i1.discounts.create!(percentage: 0.10, min_quantity: 5)
    @d2 = @i1.discounts.create!(percentage: 0.05, min_quantity: 15)
    @d3 = @i1.discounts.create!(percentage: 0.15, min_quantity: 30)
  end

  describe 'instance methods' do
    it '#view_percentage' do
      expect(@d1.view_percentage).to eq(10)
    end
  end
end
