require 'rails_helper'

RSpec.describe "Comments API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/posts/:id/comments" do

    it "makes a new comment to a post" do 
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_public
      comment_params = {
        "comment" => "A trivial comment"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts/#{post.id}/comments", comment_params, request_headers
      expect(post.comments.size).to eq 1
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["comment"]).to eq "A trivial comment"
      expect(body["post_id"]).to eq post.id
      expect(body["user"]["id"]).to eq user.id
    end

  end

  describe "GET /api/v1/posts/:id/comments" do

    it "returns all comments from a post" do 
      post = FactoryGirl.create :post_public
      c1 = FactoryGirl.create :comment, post: post
      c2 = FactoryGirl.create :comment, post: post
      get "/api/v1/posts/#{post.id}/comments", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["comments"][0]["post_id"]).to eq post.id
      expect(body["comments"][1]["post_id"]).to eq post.id
    end
    
  end

  describe "DELETE /api/v1/posts/:id/comments/:id" do

    it "deletes a comment" do
      post = FactoryGirl.create :post_public
      user = FactoryGirl.create :user
      comment = FactoryGirl.create :comment, post: post, user: user
      delete "/api/v1/posts/#{post.id}/comments/#{comment.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 204 # ok, no content
      expect(post.comments.size).to eq 0
    end
    
  end

end
