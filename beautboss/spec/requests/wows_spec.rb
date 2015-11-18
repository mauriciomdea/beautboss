require 'rails_helper'

RSpec.describe "Wows API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/posts/:id/wows" do

    it "wows a post" do 
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_private
      wow = FactoryGirl.create :wow, post: post
      post "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(Post.find(post.id).wows.size).to eq 2
      expect(Post.find(post.id).wows_count).to eq 2
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["post_id"]).to eq post.id
      expect(body["user"]["id"]).to eq user.id
    end

    it "does not create duplicate wows" do 
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_private
      wow = FactoryGirl.create :wow, post: post, user: user
      post "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(Post.find(post.id).wows.size).to eq 1
      expect(Post.find(post.id).wows_count).to eq 1
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["post_id"]).to eq post.id
      expect(body["user"]["id"]).to eq user.id
    end

  end

  describe "GET /api/v1/posts/:id/wows" do

    it "returns all wows from a post" do 
      post = FactoryGirl.create :post_private
      for i in 0..2
        FactoryGirl.create :wow, post: post
      end
      get "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 3
      expect(body["wows"][0]["post_id"]).to eq post.id
      expect(body["wows"][1]["post_id"]).to eq post.id
      expect(body["wows"][2]["post_id"]).to eq post.id
    end
    
  end

  describe "DELETE /api/v1/posts/:id/wows/:id" do

    it "de-wows a post" do
      post = FactoryGirl.create :post_private
      user = FactoryGirl.create :user
      wow = FactoryGirl.create :wow, post: post, user: user
      delete "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 204 # ok, no content
      expect(Post.find(post.id).wows.size).to eq 0
      expect(Post.find(post.id).wows_count).to eq 0
    end
    
  end

end
