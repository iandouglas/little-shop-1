class MerchantsController < ApplicationController
before_action :require_merchant
skip_before_action :require_merchant, only: [:index]
  def index
    @merchants = User.active_merchant
    @top = User.top_three_merchants_overall
    @fastest = User.three_fastest
    @slowest = User.three_slowest
    @states = User.top_three_states_overall
    @citystates = User.top_three_city_states_overall
    @orders = User.three_biggest_orders
    @total_revenue = User.total_sales_array
    @top_three = User.top_merchants_array
    @biggest = User.biggest_orders_array
    @fastest_array = User.fastest_array
    @slowest_array = User.slowest_array
    @overall_states = User.states_overall_array
    @overall_cities = User.cities_overall_array
  end

  def show
    @merchant = User.find(current_user.id)
    @items = Item.merchant_items(current_user)
    @orders = @merchant.merchant_pending_orders
    @popular_five = @items.popular_five
    @top_3_states = User.top_three_states(@merchant)
    @top_3_cities = User.top_three_city_states(@merchant)
    @top_user = User.top_user_by_orders(@merchant)
    @top_user_by_items = User.top_user_by_items(@merchant)
    @top_users_by_revenue = User.top_users_by_revenue(@merchant)

    @monthly_revenue = @merchant.monthly_revenue_array
    @daily_revenue = @merchant.daily_revenue_array
    @percent = @merchant.percent_inventory_array
    @three_states_array = User.top_three_states_array(@merchant)
    @three_cities_array = User.top_three_city_states_array(@merchant)
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

end
