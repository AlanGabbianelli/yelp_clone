class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id != current_user.id
      flash[:notice] = 'You cannot edit a restaurant created by someone else'
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to restaurants_path
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      @restaurant.destroy
      flash[:notice] = 'Restaurants deleted successfully'
    else
      flash[:notice] = 'You cannot delete a restaurant created by someone else'
    end
    redirect_to restaurants_path
  end

  def restaurant_params
    new_params = params.require(:restaurant).permit(:name, :image)
    new_params[:user_id] = current_user.id
    new_params
  end
end
