class Api::V1::BlockedController < Api::V1::ApiController
  before_action :authenticate_user

  def index
    # blocked = @current_user.blocked.limit(params[:limit] || 20).offset(params[:offset] || 0)
    blocked = @current_user.blocked
    serialized_blocked = blocked.map { |user| UserBasicSerializer.new(user).as_json(root: false) }
    render json: {count: @current_user.blocked.size, blocked: serialized_blocked},
      location: "/api/v1/users/#{@current_user.id}/blocked",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  rescue => err
    render json: {error: err.to_s}, status: 422
  end

  def create
    @user = User.find(params[:id])
    if @current_user.block(@user)
      serialized_users = @current_user.blocked.map { |user| UserBasicSerializer.new(user).as_json(root:false) }
      render json: { count: @current_user.blocked.size, blocked: serialized_users },
        location: "/api/v1/users/#{@current_user.id}/blocked",
        status: :created
    else
      render json: { errors: @current_user.errors.full_messages }, status: 422
    end
  rescue => err
    render json: {error: err.to_s}, status: 422
  end

  def destroy
    @user = User.find(params[:id])
    if @current_user.unblock(@user)
      serialized_users = @current_user.blocked.map { |user| UserBasicSerializer.new(user).as_json(root:false) }
      render json: { count: @current_user.blocked.size, blocked: serialized_users },
        location: "/api/v1/users/#{@current_user.id}/blocked",
        status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: 422
    end
  rescue => err
    render json: {error: err.to_s}, status: 422
  end

end
