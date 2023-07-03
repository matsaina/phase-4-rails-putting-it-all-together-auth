class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { error: 'Unauthorized username and password' }, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { message: 'Successfully logged out' }
  end
end
