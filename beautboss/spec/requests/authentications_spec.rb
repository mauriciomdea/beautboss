require 'rails_helper'

RSpec.describe "Authentications", type: :request do

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

  describe "DELETE /api/v1/authentications" do

    it "destroys authentication token (and log user out)" do
      user = FactoryGirl.create :user
      token = Token.get_token(user, 1)
      delete api_v1_authentication_path(token), {}, { "Accept" => "application/json", "HTTP_TOKEN" => token }
      expect(response.status).to eq 204 # ok, no content
    end

  end

end
