class User < ApplicationRecord
  attr_accessor :skip_password_validation
  has_many :items
  has_many :orders
  has_many :user_coupons
  has_many :coupons, through: :user_coupons


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

  def monthly_revenue_array
    relations = OrderItem.where(item_id: self.items, fulfilled: true).select("EXTRACT(MONTH FROM order_items.updated_at) as month","SUM(order_items.quantity*order_items.order_price)").group("EXTRACT(MONTH FROM order_items.updated_at)")
    relations.inject([]) do |array,relation|
      array << [relation.month.to_int,relation.sum]
    end
  end

  def daily_revenue_array
    relations = OrderItem.where(item_id: self.items, fulfilled: true).select("EXTRACT(DAY FROM order_items.updated_at) as day","SUM(order_items.quantity*order_items.order_price)").group("EXTRACT(DAY FROM order_items.updated_at)")
    relations.inject([]) do |array,relation|
      array << [relation.day.to_int,relation.sum]
    end
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

  def percent_inventory_array
    [["sold", total_quantity_sold],["unsold",(total_inventory - total_quantity_sold)]]
  end

  def my_used_coupons?(coupon_name)
    if coupons.pluck(:name).include?(coupon_name)
      return true
    else
      return false
    end
  end

  def self.top_three_states(merchant)
    joins(orders: :order_items).select(:state,"SUM(order_items.quantity)").where("order_items.fulfilled": true, "order_items.item_id": merchant.items.ids).group(:state).order("sum(order_items.quantity) DESC").limit(3)
  end

  def self.top_three_states_array(merchant)
    self.top_three_states(merchant).inject([]) do |array,relation|
      array << [relation.state, relation.sum]
    end
  end

  def self.top_three_city_states(merchant)
    joins(orders: :order_items).select("DISTINCT (users.city || ', ' || users.state) AS citystate","SUM(order_items.quantity)").where("order_items.fulfilled": true, "order_items.item_id": merchant.items.ids).group("citystate").order("sum(order_items.quantity) DESC").limit(3)
  end

  def self.top_three_city_states_array(merchant)
    self.top_three_city_states(merchant).inject([]) do |array,relation|
      array << [relation.citystate, relation.sum]
    end
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
    joins(orders: :order_items).where("order_items.fulfilled": true).select("orders.id", "sum(order_items.quantity)").group("orders.id").order("sum(order_items.quantity) DESC").limit(3)
  end

  def self.total_sales_array
    joins(items: :order_items).where("order_items.fulfilled": true).select(:name,"SUM(quantity*current_price)").group(:name).order("SUM(quantity*current_price) desc").inject([]) do |array, relation|
        array << [relation.name,relation.sum]
      end
  end

  def self.top_merchants_array
    self.total_sales_array[0,3]
  end

  def self.biggest_orders_array
    self.three_biggest_orders.inject([]) do |array,relation|
      array << [relation.id.to_s, relation.sum]
    end
  end

  def self.fastest_array
    self.three_fastest.inject([]) do |array, relation|
      array << [relation.name, relation.avg]
    end
  end

  def self.slowest_array
    self.three_slowest.inject([]) do |array, relation|
      array << [relation.name, relation.avg]
    end
  end

  def self.states_overall_array
    self.top_three_states_overall.inject([]) do |array,relation|
      array << [relation.state,relation.count]
    end
  end

  def self.cities_overall_array
    self.top_three_city_states_overall.inject([]) do |array,relation|
      array << [relation.citystate,relation.count]
    end
  end
end
