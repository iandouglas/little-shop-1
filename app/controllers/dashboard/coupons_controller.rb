class Dashboard::CouponsController < ApplicationController
  before_action :require_merchant
  before_action :coupon_limit, only: [:new, :create]
  before_action :coupon_used, only: [:destroy]

  def index
    @coupons = current_user.coupons
    @count = @coupons.count
  end

  def show
    @coupon = Coupon.find(params[:id])
    @users = @coupon.customers
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      current_user.coupons << @coupon
      redirect_to dashboard_coupons_path, success: "You have successfully added #{@coupon.name}"
    else
      flash.now[:danger] = "Coupon name already taken"
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update(update_params)
    redirect_to dashboard_coupon_path(coupon), success: "You have successfully updated #{coupon.name}"
  end

  def deactivate
    coupon = Coupon.find(params[:id])
    coupon.update(active: 1)
    redirect_to dashboard_coupon_path(coupon)
  end

  def activate
    coupon = Coupon.find(params[:id])
    coupon.update(active: 0)
    redirect_to dashboard_coupon_path(coupon)
  end

  def destroy
    coupon = Coupon.find(params[:id])
    coupon.destroy
    redirect_to dashboard_coupons_path, success: "You have deleted #{coupon.name}"
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def coupon_limit
    render file: "/public/404" unless coupon_limit?
  end

  def coupon_used
    render file: "/public/404" unless coupon_unused?
  end

  def coupon_params
    params.require(:coupon).permit(:name,:discount,:amount)
  end

  def update_params
    up = params.require(:coupon).permit(:name,:discount,:amount)
  end
end
