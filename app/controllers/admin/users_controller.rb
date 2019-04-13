class Admin::UsersController < ApplicationController
  before_action :require_admin
  def index
    @users = User.where(role: 0).order(:id)
  end

  def show
    if User.find_by_slug(params[:slug]).role == "merchant"
      redirect_to admin_merchant_path(User.find_by_slug(params[:slug]))
    else
      @user = User.find_by_slug(params[:slug])
    end
  end

  def update
    # binding.pry
    @user = User.find_by_slug(params[:slug])
    if params[:update] == "upgrade"
      @user.update(role: 1)
      redirect_to admin_merchant_path(@user), success: "#{@user.name} has been upgraded to a merchant"
    end
  end

  private

  def require_admin
    render file: "/public/404" unless current_admin?
  end


end
