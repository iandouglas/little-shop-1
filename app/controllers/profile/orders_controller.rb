class Profile::OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def create
    new_order = current_user.orders.create(status: "pending")
    @coupon = Coupon.find_by(name: session[:coupon])
    session[:cart].each do |item_id, quantity|
      base_price = Item.find(item_id).current_price
      if @coupon && @coupon.item_list.pluck(:id).include?(item_id.to_i)
        discount = 0
        discount_remainder = @coupon.amount - discount
        if @coupon.discount == "percent"
          order_item_price = Item.find(item_id).current_price * @coupon.percent_off
        elsif  base_price <= @coupon.amount
          order_item_price = 0
          discount_remainder = 0
        elsif  base_price > @coupon.amount
          order_item_price = Item.find(item_id).current_price - discount_remainder
          discount_remainder - order_item_price
        end
      else
        order_item_price = base_price
      end

      OrderItem.create(order_id: new_order.id,
                        item_id: item_id,
                       quantity: quantity,
                    order_price: order_item_price)
    end
    if @coupon
      current_user.coupons << @coupon
      current_user.orders.last.update(coupon_id: @coupon.id)
    end
    session.delete(:cart)
    session.delete(:coupon)
    redirect_to profile_orders_path, success: 'Your order was successfully created!'
  end

  def show
    @order = Order.find(params[:id])
    if @order.coupon_id
      @coupon = Coupon.find(@order.coupon_id.to_i)
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.update(status: 3)
    redirect_to profile_path, danger: "Order #{@order.id} has been cancelled"
  end
end
