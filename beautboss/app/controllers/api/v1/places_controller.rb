class Api::V1::PlacesController < Api::V1::ApiController
  before_action :authenticate_user

  def index
    places = Place.search(place_params[:latitude], place_params[:longitude], place_params[:query])
    serialized_places = places.map { |place| PlaceSerializer.new(place).as_json(root: false) }
    render json: serialized_places,
      location: "/api/v1/places",
      status: :ok
  rescue Foursquare2::APIError => err
    render json: {error: err.message}, status: :unprocessable_entity
  end

  def show 
    place = Place.find(params[:id])
    render json: PlaceSerializer.new(place).as_json(root: false),
      location: "/api/v1/places/#{place.id}",
      status: status
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  end

  def create
    place = Place.new(place_params)
    if place.save
      render json: PlaceSerializer.new(place).as_json(root: false),
        location: "/api/v1/places/#{place.id}",
        status: :created
    else
      render json: { errors: place.errors.full_messages }, status: 422
    end
  end

  def posts 
    place = Place.find(params[:id])
    count = place.posts.size
    posts = place.posts.limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_posts = posts.map { |post| RegisterSerializer.new(Register.new(post: post, observer: @current_user)).as_json(root:false) }
    render json: {count: count, posts: serialized_posts},
      location: "/api/v1/places/#{place.id}/posts",
      status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Not found"}, status: :not_found, root: false
    end

  private

    def place_params
      params.permit(:foursquare_id, :name, :latitude, :longitude, :address, :contact, :website, :query)
    end

end
