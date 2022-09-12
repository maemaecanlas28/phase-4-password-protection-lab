class UsersController < ApplicationController
  before_action :authorize, only: [:show]

  def create
    # create a new user
    user = User.create(user_params)
    # save their hashed password in the database
    if user.valid?
      session[:user_id] = user.id
      render json: user, status: :created
    else 
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
    # save the user's ID in the session hash
    # return the user object in the JSON response

  def show
    user = User.find_by(id: session[:user_id])
    render json: user
  end

  private

  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end
