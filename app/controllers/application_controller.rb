class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success, :info, :warning, :danger, :notice

  helper_method :current_user,
                :current_user?,
                :current_merchant?,
                :current_admin?,
                :create_slug

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

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def create_slug(params)
    params[:user][:slug] = params[:user][:email_address].parameterize
  end

  def create_item_slug(params)
    if Item.find_by_item_name(params[:item_name])
      params[:item][:slug] = (params[:item][:item_name]+params[:item][:id]).parameterize
    else
      params[:item][:slug] = params[:item][:item_name].parameterize
    end
  end

end
