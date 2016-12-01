class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :load_restaurant, only: [:create, :update, :destroy]
  before_action :load_review, only: [:update, :destroy]

  respond_to :html

  def index
    @reviews = Review.all.order(updated_at: :desc).paginate(:page => params[:page], :per_page => 15)
    @restaurants = Restaurant.select( "restaurants.*, count(reviews.id) AS reviews_count" )
                       .joins( "LEFT OUTER JOIN reviews ON reviews.restaurant_id = restaurants.id" )
                       .group( "restaurants.id" )
    @restaurants.order(title: :desc)
  end

  def create
    @review = @restaurant.reviews.build(review_params.merge(user_id: current_user.id))
    @review.save
    respond_with @restaurant
  end

  def update
    @review.update(review_params)
    respond_with @restaurant
  end

  def destroy
    @review.destroy
    respond_with @restaurant
  end

  private

  def load_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def load_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:body)
  end
end
