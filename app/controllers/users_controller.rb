class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]

  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id
      render json: { id: user.id, username: user.username, image_url: user.image_url, bio: user.bio }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: session[:user_id])
    if user
      render json: user
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:username, :password, :image_url, :bio, :password_confirmation)
  end

  def authenticate_user
    unless logged_in?
      render json: { errors: "Unauthorized" }, status: :unauthorized
    end
  end

  def logged_in?
    session[:user_id].present?
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end
