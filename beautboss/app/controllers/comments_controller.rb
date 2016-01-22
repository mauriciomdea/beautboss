class CommentsController < ApplicationController
  before_action :authenticate_user

  def create
    user = @current_user
    post = Post.find(comment_params[:post_id])
    @comment = Comment.new(post: post, user: user, comment: comment_params[:comment])
    if @comment.save
      # saves activity
      activity = Activity.create(owner: post.user, actor: user, subject: @comment)
      # sends notifications
      unless @current_user == post.user
        msg = I18n.t('notifications.comment', name: @current_user.name, comment: @comment.comment)
        device = Device.where(user: post.user).last
        device.push_notification(msg, ActivitySerializer.new(activity).as_json(root: false)) unless device.nil?
      end
      respond_to do |format|
        format.js
      end
    else
      logger.info @comment.errors.full_messages
    end
  rescue ActiveRecord::RecordNotFound
    logger.info "Post not found"
  end

  private

    def comment_params
      params.require(:comment).permit(:post_id, :comment)
    end

end
