class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success, :info, :warning, :danger, :notice

  helper_method :current_user,
                :current_user?,
                :current_merchant?,
                :current_admin?

  before_action :set_cart

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?
    current_user && current_user.user?
  end

  def current_merchant?
    current_user && current_user.merchant? && current_user.enabled?
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def coupon_limit?
    current_user.coupons.count < 5
  end

  def coupon_unused?
    Coupon.find(params[:id]).users.count == 1
  end

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end
end
