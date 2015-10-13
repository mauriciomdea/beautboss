require 'rails_helper'

RSpec.describe "Places API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/places" do

    it "creates a new place" do
      place_params = {
        "foursquare_id": "0000000x000x000xx000x00x",
        "name": "Example Haircut",
        "latitude": "-23.99440171762515",
        "longitude": "-46.15780148090618",
        "address": "SP, Brasil",
        "contact": "+551155555555"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token
      }
      post "/api/v1/places", place_params, request_headers
      expect(response.status).to eq 201 # created
      expect(Place.last.name).to eq "Example Haircut"  # did it save place to DB?
      body = JSON.parse(response.body)
      expect(body["id"]).to eq Place.last.id           # did it return the place id?
    end

  end

  describe "GET /api/v1/places" do

    it "gets all nearby venues from foursquare" do 
      place_params = {
        "latitude" => "-23.35",
        "longitude" => "-46.46",
        "query" => "hair"
      }
      # }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token
      }
      get "/api/v1/places", place_params, request_headers
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(Place.search(place_params["latitude"], place_params["longitude"], place_params["query"]).size).to eq body.size
    end

  end

  describe "GET /api/v1/places/:id" do

    it "returns requested place/venue" do 
      place = FactoryGirl.create :place, name: "Some place"
      get "/api/v1/places/#{place.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["id"]).to eq place.id
      expect(body["name"]).to eq "Some place"
    end

  end

end
