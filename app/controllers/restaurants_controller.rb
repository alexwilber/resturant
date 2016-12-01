class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  respond_to :html

  def index
    @restaurants = Restaurant.all.order(title: :asc)
    @new_restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.create(restaurant_params)
    respond_with @restaurant
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @reviews = @restaurant.reviews.all.order(updated_at: :desc)
    @new_review = @restaurant.reviews.build
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:title)
  end
end
