class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: :create

  def show
    render json: User.find(params[:id]), root: false
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
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
    verify_user
    user = @current_user
    user.name = user_params[:name]
    user.email = user_params[:email]
    user.password = user_params[:password]
    user.avatar = user_params[:avatar]
    user.website = user_params[:website]
    user.location = user_params[:location]
    user.bio = user_params[:bio]
    if user.save
      render json: UserSerializer.new(user).as_json,
      location: "/api/v1/users/#{user.id}",
      status: :ok,
      root: false
    else
     render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def destroy
    if @current_user.destroy
      Token.destroy_token(request.headers['HTTP_TOKEN'])
      head :no_content
    end
  end

end

# def default_serializer_options
#   {root: false}
# end

private

  def user_params
    params.permit(:name, :email, :password, :avatar, :website, :location, :bio)
  end
