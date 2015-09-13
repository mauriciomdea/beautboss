require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  # returns auth token
  describe "POST /api/v1/authentications" do

    it "retrieves access token from user email and password" do
      user = FactoryGirl.create :user
      auth_params = {
        "email" => "#{user.email}",
        "password" => "#{user.password}"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/authentications", auth_params, request_headers
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["token"]).not_to be_empty
    end

    it "refuses authentication for wrong email and/or password" do
      auth_params = {
        "email" => nil,
        "password" => nil
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/authentications", auth_params, request_headers
      expect(response.status).to eq 404 # not found
    end

  end

  # receives Facebook's access_token and returns a (new or saved) user 
  describe "POST /api/v1/authentications/facebook" do 

    it "refuses empty Facebook access token" do
      auth_params = nil
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/authentications/facebook", auth_params, request_headers
      expect(response.status).to eq 422 # unprocessable entity
      body = JSON.parse(response.body)
      expect(body["error"]).to eq "An active access token must be used to query information about the current user."
    end

    it "refuses invalid Facebook access token" do
      auth_params = {
        "access_token" => "an invalid access token"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/authentications/facebook", auth_params, request_headers
      expect(response.status).to eq 422 # unprocessable entity
      body = JSON.parse(response.body)
      expect(body["error"]).to eq "Invalid OAuth access token."
    end

  end

  describe "DELETE /api/v1/authentications" do

    it "destroys authentication token (and log user out)" do
      user = FactoryGirl.create :user
      token = Token.get_token(user, 1)
      delete api_v1_authentication_path(token), {}, { "Accept" => "application/json", "HTTP_TOKEN" => token }
      expect(response.status).to eq 204 # ok, no content
      expect(Token.get_user(token)).to be_nil
    end

  end

end
