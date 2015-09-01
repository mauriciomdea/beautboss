class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: :create

  def show
    render json: User.find(params[:id]), root: false
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: 404, root: false
  end

  def create
    user = User.new(
      name: user_params[:name],
      email: user_params[:email],
      password: user_params[:password]
    )
    if user.save
      render json: UserSerializer.new(user).as_json,
        location: "/api/v1/users/#{user.id}",
        status: :created,
        root: false
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def update
  end

  def destroy
  end
end

def default_serializer_options
  {root: false}
end

private

  def user_params
    params.permit(:name, :email, :password)
  end
