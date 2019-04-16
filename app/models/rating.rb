class Rating < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :description
  validates_numericality_of :rating, {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5}

  def reviewer_name
    user = User.find(user_id)
    user.name
  end

  def edited?
    created_at != updated_at
  end

  def item_name
    item = Item.find(item_id)
    item.item_name
  end
end
