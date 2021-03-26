class Api::UsersController < ApplicationController
  def index
    users = User.all
    users = users.search_by(params[:query]) if params[:query]
    render json: { users: users.recents.as_json(only: serialized_user_fields) }
  end

  def create
    user = User.new(user_create_params)
    user.key = SecureRandom.base64
    if user.save
      AccountKeyServiceJob.perform_async(user.id)
      render status: :created, json: user.as_json(only: serialized_user_fields)
    else
      render status: :unprocessable_entity, json: { errors: user.errors.full_messages }
    end
  end

  private

  def serialized_user_fields
    %i[email phone_number full_name key account_key metadata]
  end

  def user_create_params
    params.permit(:email, :phone_number, :full_name, :password, :metadata)
  end
end
