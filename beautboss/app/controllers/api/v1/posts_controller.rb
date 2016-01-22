class Api::V1::PostsController < Api::V1::ApiController
  before_action :authenticate_user

  def index
    params.require(:category)
    params.require(:latitude)
    params.require(:longitude)
    posts = Post.where(category: params[:category]).where("service LIKE :service", service: "%#{post_params[:service]}%")
    # have_place = true for public places, false for private, null for both
    posts = posts.where.not(place: nil) if params[:have_place] && params[:have_place] == "true"
    posts = posts.where(place: nil) if params[:have_place] && params[:have_place] == "false"
    posts = posts.within(params[:distance] || 10, origin: "#{params[:latitude]},#{params[:longitude]}", order: "distance asc").limit(params[:limit] || 20).offset(params[:offset] || 0)
    # ordering
    posts.sort_by{|p| p.distance_to("#{params[:latitude]},#{params[:longitude]}")} if (params[:order] && params[:order] == "closest")
    posts = posts.order(created_at: :desc) if (params[:order] && params[:order] == "latest") || (!params[:order] || params[:order] == nil)
    posts = posts.order('wows_count DESC') if (params[:order] && params[:order] == "best")
    # list all posts without distance for remote locations without posts nearby
    if posts.empty?
      posts = Post.where(category: params[:category]).where("service LIKE :service", service: "%#{post_params[:service]}%").order('wows_count DESC')
      posts = posts.where.not(place: nil) if params[:have_place] && params[:have_place] == "true"
      posts = posts.where(place: nil) if params[:have_place] && params[:have_place] == "false"
    end
    # response 
    serialized_posts = posts.map { |post| RegisterSerializer.new(Register.new(post: post, observer: @current_user)).as_json(root:false) }
    render json: {count: posts.size, posts: serialized_posts},
      location: "/api/v1/users/#{@current_user.id}/posts",
      status: :ok
  rescue => err
    render json: {error: err.to_s}, status: 422
  end

  def show
    post = Post.find(params[:id])
    render json: RegisterSerializer.new(Register.new(post: post, observer: @current_user)).as_json(root:false),
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
    post.comments << Comment.new(user: @current_user, comment: post_params[:caption]) unless post_params[:caption].nil?
    if post.save
      Activity.create(owner: @current_user, actor: @current_user, subject: post)
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
    post = Post.find(params[:id]) 
    if post.user == @current_user
      post.destroy
      head :no_content
    else
      _not_authorized
    end
  end

  private

    def post_params
      params.permit(:service, :image, :foursquare_id, :category, :latitude, :longitude, :caption, :have_place)
    end

end
