class Profile::RatingsController < ApplicationController

  def index
    @ratings = current_user.ratings
  end

  def edit
    @rating = Rating.find(params[:id])
  end

  def update
    @rating = Rating.find(params[:id])
    if @rating.update(update_params)
      redirect_to profile_ratings_path, success: "Your review has been edited!"
    else
      render :edit
    end
  end

  def destroy
    Rating.find(params[:id]).destroy
    redirect_to profile_ratings_path, success: "Your review has been deleted!"
  end

  private

  def update_params
    up = params.require(:rating).permit(:item_id,
                                        :user_id,
                                        :title,
                                        :description,
                                        :rating)
  end

end
