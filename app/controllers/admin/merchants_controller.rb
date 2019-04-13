class Admin::MerchantsController < ApplicationController
  before_action :require_admin

  def show
    if User.find_by_slug(params[:slug]).role == "user"
      redirect_to admin_user_path(User.find_by_slug(params[:slug]))
    else
      @merchant = User.find_by_slug(params[:slug])
      @orders = @merchant.merchant_pending_orders
      @popular_five = @merchant.items.popular_five
      @top_3_states = User.top_three_states(@merchant)
    end
  end

  def index
    @merchants = User.where(role: 1).order(:name)
  end

  def deactivate
    @merchant = User.find_by_slug(params[:slug])
    @merchant.update(enabled: false)
    redirect_to admin_merchants_path,  danger: "Merchant #{@merchant.id} has been disabled"
  end

  def activate
    @merchant = User.find_by_slug(params[:slug])
    @merchant.update(enabled: true)
    redirect_to admin_merchants_path, success: "Merchant #{@merchant.id} has been enabled"
  end

  def downgrade
    @merchant = User.find_by_slug(params[:slug])
    @merchant.items.each do |item|
      item.update(enabled: false)
    end
    @merchant.update(role: 'user')
    redirect_to admin_user_path(@merchant), success: "Merchant #{@merchant.id} has been downgraded to a user"
  end

  private

    def require_admin
      render file: "/public/404" unless current_admin?
    end


end
