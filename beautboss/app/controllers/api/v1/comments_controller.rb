class Api::V1::CommentsController < Api::V1::ApiController
  before_action :authenticate_user

  def index
    post = Post.find(params[:post_id])
    comments = post.comments.limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_comments = comments.map { |comment| CommentSerializer.new(comment).as_json(root: false) }
    render json: {count: post.comments.size, comments: serialized_comments},
      location: "/api/v1/posts/#{post.id}/comments",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def create
    user = @current_user
    post = Post.find(params[:post_id])
    comment = Comment.new(post: post, user: user, comment: comment_params["comment"])
    if comment.save
      Activity.create(owner: post.user, actor: user, subject: comment)
      render json: CommentSerializer.new(comment).as_json(root: false),
        location: "/api/v1/posts/#{post.id}/comments",
        status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: 422
    end
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  def destroy
    # comment = Comment.find_by(post_id: params[:post_id], user_id: @current_user.id)
    comment = Comment.find(params[:id])
    if comment.user == @current_user
      comment.destroy
      head :no_content
    else
      _not_authorized
    end
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  private

    def comment_params
      params.permit(:comment)
    end

end
