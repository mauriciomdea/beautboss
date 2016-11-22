class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authenticate_user

  def index 
    @user = @current_user
    @sender = User.find(params[:id])
    messages = Message.where(
                Message.arel_table[:user_id].eq(@user.id).and(
                  Message.arel_table[:sender_id].eq(@sender.id)).or(
                    Message.arel_table[:user_id].eq(@sender.id).and(
                      Message.arel_table[:sender_id].eq(@user.id)
                  )
                )
              )
    messages = messages.order(created_at: :desc).limit(params[:limit] || 100).offset(params[:offset] || 0)
    messages = messages.where("created_at >= ?", params[:date].to_time) unless params[:date].nil?
    serialized_messages = messages.map { |msg| MessageSerializer.new(msg).as_json(root: false) }
    render json: { count: serialized_messages.size, messages: serialized_messages},
      location: "/api/v1/users/#{@user.id}/messages",
      status: :ok
  end

end