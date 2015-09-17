class Api::V1::PlacesController < ApplicationController
  before_action :authenticate_user

  def index
    places = Place.search(place_params[:lat], place_params[:lon], place_params[:query])
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

  private

    def place_params
      params.permit(:foursquare_id, :name, :lat, :lon, :address, :contact, :website, :query)
    end

end
