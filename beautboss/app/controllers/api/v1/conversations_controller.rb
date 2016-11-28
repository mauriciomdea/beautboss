class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authenticate_user

  def index 
    @user = @current_user
    @sender = User.find(params[:sender_id])
    messages = get_messages(@sender, @user)
    messages = messages.order(created_at: :desc).limit(params[:limit] || 100).offset(params[:offset] || 0)
    messages = messages.where("created_at >= ?", params[:date].to_time) unless params[:date].nil?
    serialized_messages = messages.map { |msg| MessageSerializer.new(msg).as_json(root: false) }
    render json: { count: serialized_messages.size, messages: serialized_messages},
      location: "/api/v1/users/#{@user.id}/messages",
      status: :ok
  end

  def destroy 
    verify_user
    messages = get_messages(User.find(params[:sender_id]), @current_user).delete_all
    if messages > 0
      render json: { count: messages.to_json },
        location: "/api/v1/users/#{@current_user.id}/messages",
        status: :ok
    else
      render json: { errors: messages.errors.full_messages }, status: 422
    end
  rescue ActiveRecord::ActiveRecordError => err 
    render json: { errors: err.to_s }, status: 422
  end

  private

    def get_messages(sender, user)
      messages = Message.where(
                  Message.arel_table[:user_id].eq(user.id).and(
                    Message.arel_table[:sender_id].eq(sender.id)).or(
                      Message.arel_table[:user_id].eq(sender.id).and(
                        Message.arel_table[:sender_id].eq(user.id)
                    )
                  )
                )
    end

end