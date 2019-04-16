class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :user

  enum status: ["pending", "packaged", "shipped", "cancelled"]

  def item_quantity
    OrderItem.where(order_id: self.id).sum(:quantity)
  end

  def total
    OrderItem.where(order_id: self.id).sum("quantity*order_price")
    #SELECT sum(quantity*order_price) FROM order_items WHERE order_id = 1;
  end

  def item_fulfilled?(item)
    order_items.where(item_id: item.id).first.fulfilled?
  end

  def order_fulfilled?
    order_items.all? do |order_item|
      order_item.fulfilled?
    end
  end

  def user_name
    user = User.find(self.user_id)
    user.name
  end

  def shipped?
    status == "shipped"
  end


end
