require 'rails_helper'

RSpec.describe "Users API v1", type: :request do

  describe "POST /api/v1/users" do

    it "creates a new user" do
      user_params = {
        "name" => "John Doe",
        "email" => "john_doe@example.com",
        "password" => "1234"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/users", user_params, request_headers
      expect(response.status).to eq 201 # created
      expect(User.first.name).to eq "John Doe"
    end

    it "returns an error for invalid user" do
      user_params = {
        "name" => ""
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/users", user_params, request_headers
      expect(response.status).to eq 422 # unprocessable entity
    end

  end
  
  describe "GET /api/v1/users/:id" do

    it "returns requested user" do
      user = FactoryGirl.create :user, name: "John Doe"
      token = Token.get_token(user, 1)
      get "/api/v1/users/#{user.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["name"]).to eq "John Doe"
    end

    it "returns not found error for unknown user" do
      user = FactoryGirl.create :user
      token = Token.get_token(user, 1)
      get "/api/v1/users/#{user.id+1}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => token  }
      expect(response.status).to eq 404 # not found
    end

  end

  # describe "GET /users" do
  #   it "works! (now write some real specs)" do
  #     get api_users_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

end
