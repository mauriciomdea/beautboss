class Api::V1::WowsController < ApplicationController
  before_action :authenticate_user

  def index
    post = Post.find(params[:id])
    wows = post.wows.limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_wows = wows.map { |wow| WowSerializer.new(wow).as_json(root: false) }
    render json: {count: post.wows.size, wows: serialized_wows},
      location: "/api/v1/posts/#{post.id}/wows",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  def create
    user = @current_user
    post = Post.find(params[:id])
    wow = Wow.where(post: post, user: user).first_or_create
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
    wow = Wow.find_by(post_id: params[:id], user_id: @current_user.id)
    wow.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

end
