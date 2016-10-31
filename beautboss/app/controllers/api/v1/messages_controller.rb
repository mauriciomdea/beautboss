class Api::V1::MessagesController < Api::V1::ApiController
  before_action :authenticate_user

  def create 
    sender = @current_user
    user = User.find(params[:id])
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

  private

    def message_params
      params.permit(:message)
    end

end
