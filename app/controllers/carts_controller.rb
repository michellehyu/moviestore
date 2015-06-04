class CartsController < ApplicationController
  before_action :authenticate_user!
 
  def show
    cart_ids = $redis.smembers current_user_cart
    @cart_movies = Movie.find(cart_ids)
    later_list_ids = $redis.smembers current_user_later_list
    @later_list_movies = Movie.find(later_list_ids)
  end
 
  def add
    $redis.sadd current_user_cart, params[:movie_id]
    render json: current_user.cart_count, status: 200
  end
 
  def remove
    $redis.srem current_user_cart, params[:movie_id]
    render json: current_user.cart_count, status: 200
  end

  def save_for_later
    $redis.srem current_user_cart, params[:movie_id]
    $redis.sadd current_user_later_list, params[:movie_id]
    redirect_to(:back) 
  end

  def move_to_cart
    $redis.srem current_user_later_list, params[:movie_id]
    $redis.sadd current_user_cart, params[:movie_id]
    redirect_to(:back) 
  end

  private
 
  def current_user_cart
    "cart#{current_user.id}"
  end
  
  def current_user_later_list
    "laterlist#{current_user.id}"
  end
end
