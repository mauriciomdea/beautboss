class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authenticate_user

  def index 
    @user = @current_user
    messages = @user.messages.order(created_at: :desc).limit(params[:limit] || 100).offset(params[:offset] || 0)
    messages = messages.where("created_at >= ?", params[:date].to_time) unless params[:date].nil?
    messages = @user.messages.group(:sender_id, :user_id)
    serialized_messages = messages.map { |msg| MessageSerializer.new(msg).as_json(root: false) }
    render json: {latest_messages: serialized_messages},
      location: "/api/v1/users/#{@user.id}/messages",
      status: :ok
  end

  def show
    message = Message.find(params[:id])
    if message.user.id == @current_user.id
      render json: MessageSerializer.new(message).as_json(root:false),
        location: "/api/v1/users/#{@current_user.id}/messages/#{message.id}",
        status: status
    else
      _not_authorized
    end
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  def create 
    sender = @current_user
    user = User.find(message_params[:user_id])
    message = Message.new(sender_id: sender.id, user_id: user.id, message: message_params["message"])
    if message.save
      # saves activity
      activity = Activity.create(owner: user, actor: sender, subject: message)
      # sends push notification
      msg = I18n.t('notifications.message', name: sender.name, comment: message.message)
      device = Device.where(user: user).last
      device.push_notification(msg, ActivitySerializer.new(activity).as_json(root: false)) unless device.nil?
      # render response
      render json: MessageSerializer.new(message).as_json(root: false),
        location: "/api/v1/users/#{user.id}/messages/#{message.id}",
        status: :created
    else
      render json: { errors: message.errors.full_messages }, status: 422
    end
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  def update
    # verify_user
    message = Message.find(params[:id])
    if message.update(read: true)
      render  json: MessageSerializer.new(message).as_json(root: false),
        location: "/api/v1/users/#{@current_user.id}/messages/#{message.id}",
        status: :ok
    else
     render json: { errors: message.errors.full_messages }, status: 422
    end
  end

  def destroy
    message = Message.find(params[:id])
    if message.sender == @current_user
      message.destroy
      head :no_content
    else
      _not_authorized
    end
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  private

    def message_params
      params.permit(:user_id, :message)
    end

end
