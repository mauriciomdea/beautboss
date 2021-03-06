require 'rails_helper'

RSpec.describe "Users API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/users" do

    it "creates a new user" do
      user_params = {
        "name" => "Johnny Test",
        "email" => "johnny_test@example.com",
        "password" => "12345678"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/users", user_params, request_headers
      expect(response.status).to eq 201 # created
      expect(User.last.name).to eq "Johnny Test"
      body = JSON.parse(response.body)
      expect(body["user"]["name"]).to eq "Johnny Test"
      expect(body["user"]["username"]).to eq "johnny_test"
      expect(body["user"]["language"]).to eq "en-US"
      expect(body["token"]).not_to be_nil
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
      current_user = FactoryGirl.create :user
      user = FactoryGirl.create :user, name: "Johnny Test"
      get "/api/v1/users/#{user.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(current_user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["name"]).to eq "Johnny Test"
      expect(body["username"]).to eq "johnny_test"
      expect(body["language"]).to eq "en-US"
      expect(body["followers"]).to eq 0
      expect(body["following"]).to eq 0
      expect(body["posts"]).to eq 0
      expect(body["is_following"]).to be false
    end

    it "returns followed user" do
      current_user = FactoryGirl.create :user
      user = FactoryGirl.create :user, name: "John Doe"
      current_user.follow(user)
      get "/api/v1/users/#{user.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(current_user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["followers"]).to eq 1
      expect(body["is_following"]).to be true
    end

    it "returns not found error for unknown user" do
      user = FactoryGirl.create :user
      get "/api/v1/users/#{user.id+1}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 404 # not found
    end

  end

  describe "PUT/PATCH /api/v1/users/:id" do

    it "updates user information" do
      user = FactoryGirl.create :user
      user_params = {
        "name" => "Jane Smith",
        "email" => "jane_smith@example.com",
        "password" => "87654321",
        "avatar" => "http://some.cdn.com/some_image.jpg",
        "website" => "example.com",
        "location" => "Somewhere, NA",
        "bio" => "Blablabla.",
        "username" => "janexxx",
        "language" => "pt-BR"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      put "/api/v1/users/#{user.id}", user_params, request_headers
      expect(response.status).to eq 200 # ok
      expect(User.find(user.id).name).to eq "Jane Smith"
      expect(User.find(user.id).username).to eq "janexxx"
      expect(User.find(user.id).website).to eq "example.com"
      expect(User.find(user.id).language).to eq "pt-BR"
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

  describe "GET /api/v1/users" do

    it "returns users by name" do
      user1 = FactoryGirl.create :user, name: "Johnny Test"
      user2 = FactoryGirl.create :user, name: "Jane Test"
      get "/api/v1/users?name=test", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["users"][0]["id"]).to eq user1.id
      expect(body["users"][1]["id"]).to eq user2.id
    end

  end

  # Followers

  describe "POST /api/v1/users/:id/follow" do 

    it "follows an user" do 
      user1 = FactoryGirl.create :user, name: "The Followed"
      user2 = FactoryGirl.create :user, name: "A Follower"
      post "/api/v1/users/#{user1.id}/follow", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user2) }
      expect(user1.followers.size).to eq 1
      expect(user1.followers.last.id).to eq user2.id
      expect(response.status).to eq 201 # created
    end

  end

  describe "DELETE /api/v1/users/:id/follow" do 

    it "unfollows an user" do 
      user1 = FactoryGirl.create :user, name: "The Followed"
      user2 = FactoryGirl.create :user, name: "A Follower"
      user2.follow(user1)
      delete "/api/v1/users/#{user1.id}/follow", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user2) }
      expect(user1.followers.size).to eq 0
      expect(response.status).to eq 204 # ok, no content
    end

  end

  describe "GET /api/v1/users/:id/followers" do 

    it "lists all followers of an user" do 
      user = FactoryGirl.create :user
      john = FactoryGirl.create :user, name: "John Doe"
      jane = FactoryGirl.create :user, name: "Jane Smith"
      john.follow(user)
      jane.follow(user)
      get "/api/v1/users/#{user.id}/followers", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["followers"][0]["name"]).to eq "John Doe"
      expect(body["followers"][1]["name"]).to eq "Jane Smith"
    end

  end

  describe "GET /api/v1/users/:id/following" do 

    it "lists all users an user follows" do 
      user = FactoryGirl.create :user
      john = FactoryGirl.create :user, name: "John Doe"
      jane = FactoryGirl.create :user, name: "Jane Smith"
      user.follow(john)
      user.follow(jane)
      get "/api/v1/users/#{user.id}/following", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["following"][0]["name"]).to eq "John Doe"
      expect(body["following"][1]["name"]).to eq "Jane Smith"
    end

  end

  # Blacklist

  describe "POST /api/v1/users/:id/block" do 

    it "blocks an user" do 
      user = FactoryGirl.create :user
      troll = FactoryGirl.create :user, name: "Internet Troll"
      post "/api/v1/users/#{troll.id}/block", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(user.blocked.size).to eq 1
      expect(user.blocked.last.id).to eq troll.id
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 1
      expect(body["blocked"][0]["name"]).to eq "Internet Troll"
    end

  end

  describe "DELETE /api/v1/users/:id/block" do 

    it "unblocks an user" do 
      user = FactoryGirl.create :user
      troll = FactoryGirl.create :user, name: "Internet Troll"
      user.block(troll)
      delete "/api/v1/users/#{troll.id}/block", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(user.blocked.size).to eq 0
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 0
    end

  end

  describe "GET /api/v1/users/:id/blocked" do 

    it "lists an user's blocked users" do 
      user = FactoryGirl.create :user
      john = FactoryGirl.create :user, name: "John Doe"
      jane = FactoryGirl.create :user, name: "Jane Smith"
      user.block(john)
      user.block(jane)
      get "/api/v1/users/#{user.id}/blocked", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["blocked"][0]["name"]).to eq "John Doe"
      expect(body["blocked"][1]["name"]).to eq "Jane Smith"
    end

  end

  # Friends

  describe "GET /api/v1/users/:id/friends" do

    xit "gets friends from Facebook" do 
      user = FactoryGirl.create :user, name: "Mauricio Almeida", facebook: "815418443"
      friend = FactoryGirl.create :user, name: "Rogerio Shimizu", facebook: "10207863495531706"
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      get "/api/v1/users/#{user.id}/friends?access_token=#{ENV['ACCESS_TOKEN']}", {}, request_headers
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 1
      expect(body["friends"][0]["name"]).to eq "Rogerio Shimizu"
    end

    it "gets friends from contact's emails" do 
      user = FactoryGirl.create :user
      friend1 = FactoryGirl.create :user, email: "one@example.com"
      friend2 = FactoryGirl.create :user, email: "two@example.com"
      friend3 = FactoryGirl.create :user, email: "three@example.com"
      user.follow(friend2)
      emails = "two@example.com,three@example.com,four@example.com"
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      get "/api/v1/users/#{user.id}/friends?emails=#{emails}", {}, request_headers
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["friends"][0]["email"]).to eq "two@example.com"
      expect(body["friends"][0]["is_following"]).to be true
    end

  end

end
