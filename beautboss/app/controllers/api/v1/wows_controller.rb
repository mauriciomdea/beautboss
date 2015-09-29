class Api::V1::WowsController < ApplicationController
  before_action :authenticate_user

  def index
    post = Post.find(params[:post_id])
    wows = post.wows
    serialized_wows = wows.map { |wow| WowSerializer.new(wow).as_json(root: false) }
    render json: serialized_wows,
      location: "/api/v1/posts/#{post.id}/wows",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def create
    user = @current_user
    post = Post.find_by(params[:post_id])
    wow = Wow.new(post: post, user: user)
    if wow.save
      Activity.create(owner: post.user, actor: user, subject: wow)
      render json: WowSerializer.new(wow).as_json(root: false),
        location: "/api/v1/posts/#{post.id}/wows",
        status: :created
    else
      render json: { errors: wow.errors.full_messages }, status: 422
    end
  end

  def destroy
    wow = Wow.find_by(post_id: params[:post_id], user_id: @current_user.id)
    wow.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

end
