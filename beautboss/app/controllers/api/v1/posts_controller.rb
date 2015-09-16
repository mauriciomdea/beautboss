class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user

  def index
    posts = @current_user.posts
    serialized_posts = posts.map { |post| PostSerializer.new(post).as_json(root: false) }
    render json: serialized_posts,
      location: "/api/v1/users/#{@current_user.id}/posts",
      status: :ok
  end

  def show
    post = Post.find(params[:id])
    render json: PostSerializer.new(post).as_json(root: false),
      location: "/api/v1/posts/#{post.id}",
      status: status
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def create
    post = Post.new(
      user: @current_user,
      caption: post_params[:caption],
      image: post_params[:image]
    )
    post.place = Place.find_by(post_params[:place_id]) 
    if post.save
      render json: PostSerializer.new(post).as_json(root: false),
        location: "/api/v1/posts/#{post.id}",
        status: :created
    else
      render json: { errors: post.errors.full_messages }, status: 422
    end
  end

  def destroy
    post = Post.find_by(params[:id]) 
    if post.user == @current_user
      post.destroy
      head :no_content
    else
      _not_authorized
    end
  end

  private

    def post_params
      params.permit(:caption, :image, :service_id, :category_id, :place_id)
    end

end
