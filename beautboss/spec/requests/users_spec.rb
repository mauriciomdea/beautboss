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

  describe "PUT/PATCH /api/v1/users/:id" do

    it "updates user information" do
      user = FactoryGirl.create :user
      token = Token.get_token(user, 1)
      user_params = {
        "name" => "Jane Smith",
        "email" => "jane_smith@example.com",
        "password" => "4321",
        "avatar" => "http://some.cdn.com/some_image.jpg",
        "website" => "example.com",
        "location" => "Somewhere, NA",
        "bio" => "Blablabla."
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => token
      }
      put "/api/v1/users/#{user.id}", user_params, request_headers
      expect(response.status).to eq 200 # ok
      expect(User.find(user.id).name).to eq "Jane Smith"
      expect(User.find(user.id).website).to eq "example.com"
    end

  end

  describe "DELETE /api/v1/users/:id" do

    it "deletes user (permanently) from the db" do
      user = FactoryGirl.create :user
      token = Token.get_token(user, 1)
      delete "/api/v1/users/#{user.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => token }
      expect(response.status).to eq 204 # ok, no content
      expect{User.find(user.id)}.to raise_error ActiveRecord::RecordNotFound
      expect(Token.get_user(token)).to be_nil
    end

  end

  # describe "GET /users" do
  #   it "works! (now write some real specs)" do
  #     get api_users_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

end
