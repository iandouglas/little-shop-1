class UsersController < ApplicationController
before_action :require_user
skip_before_action :require_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path, success: "You are now registered and logged in"
    else
      render :new
    end
  end

  def show
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find_by_slug(params[:slug])
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(update_params)
      redirect_to profile_path, success: "Profile updated"
    else
      render :edit
    end
  end

  private

  def user_params
    create_slug(params)
    params.require(:user).permit(:name,
                                 :street_address,
                                 :state,
                                 :city,
                                 :zip_code,
                                 :email_address,
                                 :password,
                                 :password_confirmation,
                                 :slug)
  end

  def update_params
    up = params.require(:user).permit(:name,
                                 :street_address,
                                 :state,
                                 :city,
                                 :zip_code,
                                 :email_address,
                                 :password,
                                 :password_confirmation)
     up.delete(:password) if up[:password].blank?
     up.delete(:password_confirmation) if up[:password_confirmation].blank?
     up
  end

  def require_user
    render file: "/public/404" unless current_user?
  end



end
