class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.new(review_params)
    unless @review.save
      flash[:notice] = 'You cannot review a restaurant more than once'
    end
    redirect_to restaurants_path
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.user_id == current_user.id
      @review.destroy
      flash[:notice] = 'Review deleted successfully'
    else
      flash[:notice] = 'You cannot delete a review created by someone else'
    end
    redirect_to restaurants_path
  end

  def review_params
    new_params = params.require(:review).permit(:thoughts, :rating)
    new_params[:user_id] = current_user.id
    new_params
  end
end
