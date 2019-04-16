class RatingsController < ApplicationController

  def new
    @rating = Rating.new(item_id: params[:item_id], user_id: params[:user_id])
  end

  def create
    @rating = Rating.new(rating_params)
    if @rating.save
      redirect_to profile_orders_path
    else
      render :new
    end
  end

  def index
  end


  private

  def rating_params
    params.require(:rating).permit(:item_id,
                                   :user_id,
                                   :title,
                                   :description,
                                   :rating)
  end
end
