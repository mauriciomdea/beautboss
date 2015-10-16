require 'rails_helper'

RSpec.describe "Posts API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  def create_example_posts 
    @public_haircut = FactoryGirl.create :post_public, category: :haircut, service: "Haircut at Someplace", latitude: '-23.5381', longitude: '-46.2191'
    @public_nails = FactoryGirl.create :post_public, category: :nails, service: "Nails at Someplace", latitude: '-23.5381', longitude: '-46.2191'
    @private_haircut = FactoryGirl.create :post_private, category: :haircut, service: "My Haircut", latitude: '-23.5381', longitude: '-46.2191'
    @private_nails = FactoryGirl.create :post_private, category: :nails, service: "My Nails", latitude: '-23.5381', longitude: '-46.2191'
    far_away_place = place = FactoryGirl.create :place, latitude: "99.9999", longitude: "99.9999"
    @far_away_register = FactoryGirl.create :post_public, category: :haircut, service: "Haircut at another town", place: far_away_place, latitude: "99.9999", longitude: "99.9999"
  end

  describe "POST /api/v1/posts" do

    it "creates a new post for a existing public place" do
      user = FactoryGirl.create :user
      place = FactoryGirl.create :place, foursquare_id: '4e31c8bb18a8dc38fe84a3e9', latitude: '-23.5381', longitude: '-46.2191'
      post_params = {
        "category" => "haircut",
        "service" => "My beautiful new haircut!",
        "image" => "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/haircut.png",
        "foursquare_id" => place.foursquare_id,
        "latitude" => place.latitude,
        "longitude" => place.longitude
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts", post_params, request_headers
      expect(response.status).to eq 201 # created
      expect(Post.last.service).to eq "My beautiful new haircut!"	# did it save post to DB?
      body = JSON.parse(response.body)
      expect(body["id"]).to eq Post.last.id       # did it return the post id?
      expect(body["category"]).to eq "haircut"    # did it return the correct category?
      expect(body["user"]["id"]).to eq user.id 	  # checks if post belongs to authorized user
      expect(body["place"]["foursquare_id"]).to eq place.foursquare_id  # checks if place was set
      expect(body["latitude"]).to eq place.latitude
      expect(body["longitude"]).to eq place.longitude
  	end

    it "creates a new post for a private place" do
      user = FactoryGirl.create :user
      place = FactoryGirl.create :place
      post_params = {
        "category" => "nails",
        "service" => "My beautiful nails!",
        "image" => "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/nails.png",
        "latitude" => "00.01",
        "longitude" => "00.02"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts", post_params, request_headers
      expect(response.status).to eq 201 # created
      expect(Post.last.service).to eq "My beautiful nails!"  # did it save post to DB?
      body = JSON.parse(response.body)
      expect(body["id"]).to eq Post.last.id     # did it return the post id?
      expect(body["category"]).to eq "nails"    # did it return the correct category?
      expect(body["user"]["id"]).to eq user.id  # checks if post belongs to authorized user
      expect(body["latitude"]).to eq 0.01
      expect(body["longitude"]).to eq 0.02
    end

    it "creates a new post for a new public place" do
      user = FactoryGirl.create :user
      post_params = {
        "category" => "haircut",
        "service" => "My beautiful new haircut!",
        "image" => "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/haircut.png",
        "foursquare_id" => '4fb18581e4b0d327d5bd0395',
        "latitude" => '-23.5742',
        "longitude" => '-46.6482'
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts", post_params, request_headers
      place = Place.last
      post = Post.last
      expect(response.status).to eq 201 # created
      expect(post.service).to eq "My beautiful new haircut!" # did it save post to DB?
      body = JSON.parse(response.body)
      expect(body["id"]).to eq post.id       # did it return the post id?
      expect(body["category"]).to eq "haircut"    # did it return the correct category?
      expect(body["user"]["id"]).to eq user.id    # checks if post belongs to authorized user
      expect(body["place"]["foursquare_id"]).to eq place.foursquare_id  # checks if place was set
      expect('%.4f' % body["place"]["latitude"].to_f).to eq place.latitude.to_s
      expect('%.4f' % body["place"]["longitude"].to_f).to eq place.longitude.to_s
    end

    it "returns an error for an invalid post" do 
      post_params = {
        "service" => ""
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
      post = FactoryGirl.create :post_public, service: "Some random post"
      get "/api/v1/posts/#{post.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["id"]).to eq post.id
      expect(body["service"]).to eq "Some random post"
    end

    it "returns not found error for unknown post" do
      post = FactoryGirl.create :post_public
      get "/api/v1/posts/#{post.id+1}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token  }
      expect(response.status).to eq 404 # not found
    end

  end

  describe "DELETE /api/v1/posts/:id" do

    it "deletes a post" do
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_public, user: user
      delete "/api/v1/posts/#{post.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 204 # ok, no content
      expect{Post.find(post.id)}.to raise_error ActiveRecord::RecordNotFound
    end

    it "refuses to delete a post from another user" do
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_public
      delete "/api/v1/posts/#{post.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 401 # forbidden
    end

  end

  describe "GET /api/v1/users/:id/posts" do

    it "returns all posts from an user" do
      user = FactoryGirl.create :user
      post1 = FactoryGirl.create :post_public, user: user, service: "Post one"
      post2 = FactoryGirl.create :post_private, user: user, service: "Post two"
      get "/api/v1/users/#{user.id}/posts", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["posts"][0]["service"]).to eq "Post one"
    end

  end

  describe "GET /api/v1/places/:id/posts" do

    it "returns all posts from a place" do
      place = FactoryGirl.create :place
      post1 = FactoryGirl.create :post_public, place: place, service: "Post one"
      post2 = FactoryGirl.create :post_private, place: place, service: "Post two"
      get "/api/v1/places/#{place.id}/posts", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["posts"][0]["service"]).to eq "Post one"
    end

  end

  describe "GET /api/v1/posts" do 

    # {
    #     "id": 1,
    #     "category": "haircut",
    #     "lat": -23.1234,
    #     "lon": -46.1234,
    #     "service": "Female Haircut",
    #     "user": {
    #         "id": 2
    #         "name": "Jane Smith"
    #         "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
    #     },
    #     "place": {
    #         "id": 123,
    #         "name": "Beau London",
    #         "lat": -23.1234,
    #         "lon": -46.1234
    #     },
    #     "wow": 26,
    #     "wow_friends": 6,
    #     "my_wow": false,
    #     "url": "http://symphony.clinic/wp-content/uploads/2015/05/haircut.jpg",
    #     "created_at": "2015-10-10T16:43:10.000Z"
    # }

    it "returns all nearby Posts" do
      create_example_posts
      post_params = {
        # "have_place" => true,
        "category" => 0,
        "latitude" => -23.5381,
        "longitude" => -46.2191
      }
      get "/api/v1/posts", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
    end

    it "returns all public Posts nearby" do 
      create_example_posts
      post_params = {
        "have_place" => true,
        "category" => 0,
        "latitude" => -23.5381,
        "longitude" => -46.2191
      }
      get "/api/v1/posts", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 1
      expect(body["posts"][0]["service"]).to eq "Haircut at Someplace"
      expect(body["posts"][0]["place"]).not_to be_nil
    end

    it "returns all private Posts nearby" do 
      create_example_posts
      post_params = {
        "have_place" => false,
        "category" => 0,
        "latitude" => -23.5381,
        "longitude" => -46.2191
      }
      get "/api/v1/posts", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 1
      expect(body["posts"][0]["service"]).to eq "My Haircut"
      expect(body["posts"][0]["place"]).to be_nil
    end

    it "returns all Posts from a Category" do 
      create_example_posts
      post_params = {
        # "have_place" => true,
        "category" => 4,
        "latitude" => -23.5381,
        "longitude" => -46.2191
      }
      get "/api/v1/posts", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["posts"][0]["category"]).to eq 'nails'
      expect(body["posts"][1]["category"]).to eq 'nails'
    end

    it "returns all nearby Posts by service name"

  end

  # Wows

  describe "POST /api/v1/posts/:id/wows" do

    it "wows a post" do 
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_public
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
      post = FactoryGirl.create :post_public
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
      post = FactoryGirl.create :post_public
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
      # expect(body["post_id"]).to eq post.id
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
      # expect(body.size).to eq 2
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