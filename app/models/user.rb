class User < ApplicationRecord
  attr_accessor :skip_password_validation
  has_many :items
  has_many :orders


  has_secure_password allow_blank: true
  validates :password, confirmation: true
  validates_presence_of :name, :street_address, :city, :state, :zip_code, :email_address
  validates_uniqueness_of :email_address
  #validates :password_confirmation, presence: true


  enum role: ['user', 'merchant', 'admin']

  def self.active_merchant
    where(role: 1, enabled: true).order(:id)
  end

  def my_item_count(order)
    OrderItem.where(item_id: self.items, order_id: order.id).sum(:quantity)
  end

  def my_total(order)
    OrderItem.where(item_id: self.items, order_id: order.id).sum("quantity*order_price")
  end

  def merchant_pending_orders
    Order.joins(:order_items).select("orders.*").where("order_items.item_id": self.items,"order_items.fulfilled": false).distinct
  end

  def total_inventory
    items.sum(:inventory)
  end

  def total_quantity_sold
    items.joins(:order_items).where("order_items.fulfilled = true").sum(:quantity)
  end

  def percentage_sold
    (total_quantity_sold / (total_inventory + total_quantity_sold).to_f) * 100
  end

  def my_discounts
    Discount.where(item_id: self.items).order(:item_id, :percentage)
  end

  def self.top_three_states(merchant)
    joins(orders: :order_items).select(:state,"SUM(order_items.quantity)").where("order_items.fulfilled": true, "order_items.item_id": merchant.items.ids).group(:state).order("sum(order_items.quantity) DESC").limit(3)
  end

  def self.top_three_city_states(merchant)
    joins(orders: :order_items).select("DISTINCT (users.city || ', ' || users.state) AS citystate","SUM(order_items.quantity)").where("order_items.fulfilled": true, "order_items.item_id": merchant.items.ids).group("citystate").order("sum(order_items.quantity) DESC").limit(3)
  end

  def self.top_user_by_orders(merchant)
    joins(orders: :order_items).where("order_items.item_id": merchant.items.ids, "order_items.fulfilled": true).select(:name, "count(orders)").group(:name).order("count(orders)").last
  end

  def self.top_user_by_items(merchant)
    joins(orders: :order_items).where("order_items.item_id": merchant.items.ids, "order_items.fulfilled": true).select(:name, "sum(order_items.quantity)").group(:name).order("sum(order_items.quantity)").last
  end

  def self.top_users_by_revenue(merchant)
    joins(orders: :order_items).where("order_items.item_id": merchant.items.ids, "order_items.fulfilled": true).select(:name, "sum(order_items.quantity * order_items.order_price)").group(:name).order("sum(order_items.quantity * order_items.order_price) DESC").limit(3)
  end



  def self.top_three_merchants_overall
    joins(items: :order_items).select("users.name","SUM(order_items.quantity * order_items.order_price)").where("order_items.fulfilled": true).group("users.name").order("SUM(order_items.quantity * order_items.order_price) DESC").limit(3)
  end

  def self.three_fastest
    joins(items: :order_items).select("users.name","AVG(order_items.updated_at - order_items.created_at)").where("order_items.fulfilled": true).group("users.name").order("AVG(order_items.updated_at - order_items.created_at)").limit(3)
  end

  def self.three_slowest
    joins(items: :order_items).select("users.name","AVG(order_items.updated_at - order_items.created_at)").where("order_items.fulfilled": true).group("users.name").order("AVG(order_items.updated_at - order_items.created_at) DESC").limit(3)
  end

  def self.top_three_states_overall
    joins(orders: :order_items).select(:state,"count(order_id)").where("order_items.fulfilled": true).group(:state).order("count(order_id) DESC").limit(3)
  end

  def self.top_three_city_states_overall
    joins(orders: :order_items).select("DISTINCT (users.city || ', ' || users.state) AS citystate","count(order_items.quantity)").where("order_items.fulfilled": true).group("citystate").order("count(order_items.quantity) DESC").limit(3)
  end

  def self.three_biggest_orders
    x = joins(orders: :order_items).where("order_items.fulfilled": true).select("orders.id", "sum(order_items.quantity)").group("orders.id").order("sum(order_items.quantity) DESC").limit(3)
  end

end
