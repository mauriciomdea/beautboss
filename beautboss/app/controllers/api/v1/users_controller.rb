class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: :create

  def index 
    users = User.where("lower(name) like ? or lower(username) like ?", "%#{params[:name].downcase}%", "%#{params[:name].downcase}%") unless params[:name].nil?
    serialized_users = users.limit(params[:limit] || 20).offset(params[:offset] || 0).map { |user| FriendSerializer.new(Friend.new(user: user, other_user: @current_user)).as_json(root:false) }
    render json: {count: users.size, users: serialized_users},
      location: "/api/v1/users",
      status: :ok
  end

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
      render json: { user: NewUserSerializer.new(user).as_json(root: false), token: @token }, location: "/api/v1/users/#{user.id}", status: :created
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
    # serialized_followers = followers.map { |user| UserBasicSerializer.new(user).as_json(root: false) }
    serialized_followers = followers.map { |user| FriendSerializer.new(Friend.new(user: user, other_user: @current_user)).as_json(root:false) }
    render json: {count: @user.followers.size, followers: serialized_followers},
      location: "/api/v1/users/#{@user.id}/followers",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def following 
    @user = User.find(params[:id])
    following = @user.following.limit(params[:limit] || 20).offset(params[:offset] || 0)
    # serialized_following = following.map { |user| UserBasicSerializer.new(user).as_json(root: false) }
    serialized_following = following.map { |user| FriendSerializer.new(Friend.new(user: user, other_user: @current_user)).as_json(root:false) }
    render json: {count: @user.following.size, following: serialized_following},
      location: "/api/v1/users/#{@user.id}/following",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def notifications 
    @user = User.find(params[:id])
    notifications = @user.notifications.unread.limit(params[:limit] || 20).offset(params[:offset] || 0)
    notifications.update_all(read: true) if params[:mark_as_read] && params[:mark_as_read] == "true"
    serialized_notifications = notifications.map { |notification| ActivitySerializer.new(notification).as_json(root: false) }
    render json: {count: @user.notifications.size, notifications: serialized_notifications},
      location: "/api/v1/users/#{@user.id}/notifications",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def posts 
    user = User.find(params[:id])
    count = user.posts.size
    posts = user.posts.limit(params[:limit] || 20).offset(params[:offset] || 0).order(created_at: :desc)
    serialized_posts = posts.map { |post| RegisterSerializer.new(Register.new(post: post, observer: @current_user)).as_json(root:false) }
    render json: {count: count, posts: serialized_posts},
      location: "/api/v1/users/#{user.id}/posts",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def friends
    friends = []
    if user_params[:emails]
      emails = params[:emails].split(/,/)
      friends = User.where("email IN (?)", emails)
    elsif user_params[:access_token]
      profile = FbGraph2::User.me(user_params[:access_token]).fetch
      profile.fetch
      ids = []
      profile.friends.each do |friend|
        ids << friend.id
      end
      friends = User.where("facebook IN (?)", ids)
    end
    serialized_friends = friends.map { |user| FriendSerializer.new(Friend.new(user: user, other_user: @current_user)).as_json(root:false) }
    render json: {count: friends.size, friends: serialized_friends },
      location: "/api/v1/users/#{params[:id]}/friends",
      status: :ok
  rescue FbGraph2::Exception  => err
    render json: {error: err.message}, status: :unprocessable_entity
  end

  private

    def user_params
      params.permit(:name, :username, :email, :password, :avatar, :website, :location, :bio, :access_token, :emails)
    end

    def _render_user(user, status = :ok)
      render json: user, serializer: UserFullSerializer, current_user: @current_user, location: "/api/v1/users/#{user.id}", status: status
      # render json: UserSerializer.new(user, current_user: @current_user).as_json(root: false),
      #   location: "/api/v1/users/#{user.id}",
      #   status: status
    end
  
end
