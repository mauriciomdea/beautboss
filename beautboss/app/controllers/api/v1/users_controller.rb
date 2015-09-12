class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: :create

  def show
    user = User.find(params[:id])
    _render_user(user)
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
      @token = Token.get_token(user)
      # _render_user(user, :created)
      render json: { user: UserSerializer.new(user).as_json(root: false), token: @token },
        location: "/api/v1/users/#{user.id}",
        status: :created
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def update
    verify_user
    user = @current_user
    if user.update(user_params)
      _render_user(user)
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

private

  def user_params
    params.permit(:name, :email, :password, :avatar, :website, :location, :bio)
  end

  def _render_user(user, status = :ok)
    render json: UserSerializer.new(user).as_json(root: false),
      location: "/api/v1/users/#{user.id}",
      status: status
  end
