class Api::V1::BlockedController < Api::V1::ApiController
  before_action :authenticate_user

  def create
    @user = User.find(params[:id])
    if @current_user.block(@user)
      # Activity.create(owner: @current_user, actor: @current_user, subject: post)
      serialized_users = @current_user.blocked.map { |user| UserBasicSerializer.new(user).as_json(root:false) }
      render json: { count: @current_user.blocked.size, blocked: serialized_users },
        location: "/api/v1/users/#{@current_user.id}/blocked",
        status: :created
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  rescue => err
    render json: {error: err.to_s}, status: 422
  end

end
