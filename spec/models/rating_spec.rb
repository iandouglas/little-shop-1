require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'relationships' do
    it {should belong_to :user}
    it {should belong_to :item}
  end

  describe 'validations' do
    it {should validate_presence_of(:title) }
    it {should validate_presence_of(:description) }
    it {should validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
    it {should validate_numericality_of(:rating).is_greater_than_or_equal_to(1) }
    it {should validate_numericality_of(:rating).only_integer }
  end

  describe 'instance methods' do
    it '.reviewer_name' do
      u4 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:1)
      u17 = User.create(name: "Leanor Dencs",street_address: "1 Cody Lane",city: "Reno",state: "Nevada",zip_code: "89502",email_address: "ldencsg@mozilla.com",password:"KPI7nrZoA", enabled: true, role:0)
      i2 = u4.items.create(item_name: "W.L. Weller C.Y.P.B.",image_url: "http://www.buffalotracedistillery.com/sites/default/files/weller%20special%20reserve%20brand%20page%5B1%5D.png",current_price: 35.0,inventory: 30, description:"A light aroma with citrus and oak on the nose. The palate is well rounded and balanced, with a medium-long finish and hints of vanilla.",enabled: true)
      rating = Rating.create(title: "this is fine", description: "I prefer vodka", rating: 3, user_id: u17.id, item_id: i2.id)

      expect(rating.reviewer_name).to eq("Leanor Dencs")
    end
  end
end
