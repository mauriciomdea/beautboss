require 'rails_helper'

RSpec.describe "Posts API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/posts" do

    it "creates a new post for a registered place" do
      user = FactoryGirl.create :user
      place = FactoryGirl.create :place
      post_params = {
        "caption" => "Post example",
        "image" => "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
        "place_id" => place.id
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts", post_params, request_headers
      expect(response.status).to eq 201 # created
      expect(Post.last.caption).to eq "Post example"	# did it save post to DB?
      body = JSON.parse(response.body)
      expect(body["id"]).to eq Post.last.id       # did it return the post id?
      expect(body["user"]["id"]).to eq user.id 	  # checks if post belongs to authorized user
      expect(body["place"]["id"]).to eq place.id  # checks if place was set
  	end

    # it "creates a new post for a new place" do
    #   user = FactoryGirl.create :user
    #   post_params = {
    #     "caption" => "Post example",
    #     "image" => "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
    #     "place" => {
    #       "foursquare_id": "0000000b498e241bb615b53b",
    #       "name": "Example Haircut",
    #       "lat": "-23.99440171762515",
    #       "lon": "-46.15780148090618",
    #       "address": "SP, Brasil",
    #       "contact": "+551155555555"
    #     }
    #   }.to_json
    #   request_headers = {
    #     "Accept" => "application/json",
    #     "Content-Type" => "application/json",
    #     "HTTP_TOKEN" => valid_auth_token(user)
    #   }
    #   post "/api/v1/posts", post_params, request_headers
    #   expect(response.status).to eq 201 # created
    #   expect(Post.last.caption).to eq "Post example"  # did it save post to DB?
    #   body = JSON.parse(response.body)
    #   expect(body["id"]).to eq Post.last.id       # did it return the post id?
    #   expect(body["user"]["id"]).to eq user.id    # checks if post belongs to authorized user
    #   expect(body["place"]["id"]).not_to be_nil   # checks if place was saved
    # end

    it "returns an error for an invalid post" do 
      post_params = {
        "caption" => ""
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token
      }
      post "/api/v1/posts", post_params, request_headers
      expect(response.status).to eq 422 # unprocessable entity
    end

  end

  describe "GET /api/v1/posts/:id" do

    it "returns requested post" do
      post = FactoryGirl.create :post, caption: "Some random post"
      get "/api/v1/posts/#{post.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["id"]).to eq post.id
      expect(body["caption"]).to eq "Some random post"
    end

    it "returns not found error for unknown post" do
      post = FactoryGirl.create :post
      get "/api/v1/posts/#{post.id+1}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token  }
      expect(response.status).to eq 404 # not found
    end

  end

  describe "DELETE /api/v1/posts/:id" do

    it "deletes a post" do
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post, user: user
      delete "/api/v1/posts/#{post.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 204 # ok, no content
      expect{Post.find(post.id)}.to raise_error ActiveRecord::RecordNotFound
    end

    it "refuses to delete a post from another user" do
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post
      delete "/api/v1/posts/#{post.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 401 # forbidden
    end

  end

  describe "GET /api/v1/users/:id/posts" do

    it "returns all posts from an user" do
      user = FactoryGirl.create :user
      post1 = FactoryGirl.create :post, user: user, caption: "Post one"
      post2 = FactoryGirl.create :post, user: user, caption: "Post two"
      get "/api/v1/users/#{user.id}/posts", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["posts"][0]["caption"]).to eq "Post one"
    end

  end

  describe "GET /api/v1/places/:id/posts" do

    it "returns all posts from a place" do
      place = FactoryGirl.create :place
      post1 = FactoryGirl.create :post, place: place, caption: "Post one"
      post2 = FactoryGirl.create :post, place: place, caption: "Post two"
      get "/api/v1/places/#{place.id}/posts", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["posts"][0]["caption"]).to eq "Post one"
    end

  end

  # Wows

  describe "POST /api/v1/posts/:id/wows" do

    it "wows a post" do 
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post
      wow = FactoryGirl.create :wow, post: post
      post "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(post.wows.size).to eq 2
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["post"]["id"]).to eq post.id
      expect(body["user"]["id"]).to eq user.id
    end

  end

  describe "GET /api/v1/posts/:id/wows" do

    it "returns all wows from a post" do 
      post = FactoryGirl.create :post
      wow1 = FactoryGirl.create :wow, post: post
      wow2 = FactoryGirl.create :wow, post: post
      get "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body.size).to eq 2
    end
    
  end

  describe "DELETE /api/v1/posts/:id/wows/:id" do

    it "de-wows a post" do
      post = FactoryGirl.create :post
      user = FactoryGirl.create :user
      wow = FactoryGirl.create :wow, post: post, user: user
      delete "/api/v1/posts/#{post.id}/wows/#{wow.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 204 # ok, no content
      expect(post.wows.size).to eq 0
    end
    
  end

  # Comments

  describe "POST /api/v1/posts/:id/comments" do

    it "makes a new comment to a post" do 
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post
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
      expect(body["user_id"]).to eq user.id
    end

  end

  describe "GET /api/v1/posts/:id/comments" do

    it "returns all comments from a post" do 
      post = FactoryGirl.create :post
      c1 = FactoryGirl.create :comment, post: post
      c2 = FactoryGirl.create :comment, post: post
      get "/api/v1/posts/#{post.id}/comments", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body.size).to eq 2
    end
    
  end

  describe "DELETE /api/v1/posts/:id/comments/:id" do

    it "deletes a comment" do
      post = FactoryGirl.create :post
      user = FactoryGirl.create :user
      comment = FactoryGirl.create :comment, post: post, user: user
      delete "/api/v1/posts/#{post.id}/comments/#{comment.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 204 # ok, no content
      expect(post.comments.size).to eq 0
    end
    
  end

end