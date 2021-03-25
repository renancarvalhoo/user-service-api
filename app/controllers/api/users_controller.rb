class Api::UsersController < ApplicationController
  def index
    render json: { users: User.all }
  end

  def create
    user = User.new(user_params)

    if user.save
      render status: :created, json: user
    else
      render status: :unprocessable_entity, json: user.errors
    end
  end

  private

  def user_params
    params.permit(:email, :phone_number, :full_name, :password, :metadata)
  end
end
