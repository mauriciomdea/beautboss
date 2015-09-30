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

  def followers 
    @user = User.find(params[:id])
    followers = @user.followers.limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_followers = followers.map { |user| UserSerializer.new(user).as_json(root: false) }
    render json: serialized_followers,
      location: "/api/v1/users/#{@user.id}/followers",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def following 
    @user = User.find(params[:id])
    following = @user.following.limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_following = following.map { |user| UserSerializer.new(user).as_json(root: false) }
    render json: serialized_following,
      location: "/api/v1/users/#{@user.id}/followers",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def notifications 
    @user = User.find(params[:id])
    notifications = @user.notifications.where(read: false).limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_notifications = notifications.map { |notification| ActivitySerializer.new(notification).as_json(root: false) }
    render json: serialized_notifications,
      location: "/api/v1/users/#{@user.id}/notifications",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
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
