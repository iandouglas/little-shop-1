class Coupon < ApplicationRecord
  has_many :user_coupons, :dependent => :destroy
  has_many :users, through: :user_coupons

  validates_presence_of :name, :discount, :amount, :active
  validates_uniqueness_of :name

  enum discount: ["dollar", "percent"]
  enum active: ["activated","deactivated"]

  def customers
    users.where(role: 0)
  end

  def item_list
    merch = users.where(role: 1).first
    Item.where(id: merch.items, enabled: true)
  end

  def percent_off
    (100 - amount)/100.0
  end

end
