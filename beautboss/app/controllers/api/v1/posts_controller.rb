class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user

  def index
    @posts = nil
    count = 0
    if params[:user_id]
      user = User.find(params[:user_id])
      count = user.posts.size
      @posts = user.posts.limit(params[:limit] || 20).offset(params[:offset] || 0)
    elsif params[:place_id]
      place = Place.find(params[:place_id])
      count = place.posts.size
      @posts = place.posts.limit(params[:limit] || 20).offset(params[:offset] || 0)
    else
      params.require(:category)
      params.require(:latitude)
      params.require(:longitude)
      if params[:have_place] && params[:have_place] == "true"
        @posts = Post.where(category: params[:category]).where("service LIKE :service", service: "%#{post_params[:service]}%").where.not(place: nil).within(10, origin: "#{params[:latitude]},#{params[:longitude]}")
      elsif params[:have_place] && params[:have_place] == "false"
        @posts = Post.where(category: params[:category], place: nil).where("service LIKE :service", service: "%#{post_params[:service]}%").within(10, origin: "#{params[:latitude]},#{params[:longitude]}")
      else
        @posts = Post.where(category: params[:category]).where("service LIKE :service", service: "%#{post_params[:service]}%").within(10, origin: "#{params[:latitude]},#{params[:longitude]}")
      end
      count = @posts.size
    end
    serialized_posts = @posts.map { |post| PostSerializer.new(post).as_json(root: false) }
    render json: {count: count, posts: serialized_posts},
      location: "/api/v1/users/#{@current_user.id}/posts",
      status: :ok
  rescue => err
    render json: {error: err.to_s}, status: 422
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
      service: post_params[:service],
      image: post_params[:image],
      latitude: post_params[:latitude],
      longitude: post_params[:longitude]
    )
    post.category = post_params[:category]
    post.place = Place.create_from_foursquare(post_params[:foursquare_id]) unless post_params[:foursquare_id].nil?
    if post.save
      render json: PostSerializer.new(post).as_json(root: false),
        location: "/api/v1/posts/#{post.id}",
        status: :created
    else
      render json: { errors: post.errors.full_messages }, status: 422
    end
  rescue => err
    render json: {error: err.to_s}, status: 422
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
      params.permit(:service, :image, :foursquare_id, :category, :latitude, :longitude, :have_place)
    end

end
