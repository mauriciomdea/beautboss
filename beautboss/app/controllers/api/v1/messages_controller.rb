class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authenticate_user

  def index 
    user = @current_user
    messages = user.messages.limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_messages = messages.map { |msg| MessageSerializer.new(msg).as_json(root: false) }
    render json: {count: user.messages.size, messages: serialized_messages},
      location: "/api/v1/users/#{user.id}/messages",
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
      # activity = Activity.create(owner: post.user, actor: user, subject: comment)
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
