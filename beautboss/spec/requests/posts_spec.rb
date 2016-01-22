require 'rails_helper'

RSpec.describe "Posts API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  def create_example_posts 
    @public_haircut = FactoryGirl.create :post_public, category: :haircut, service: "Haircut at Someplace", latitude: '-23.538103', longitude: '-46.219103'
    @public_nails = FactoryGirl.create :post_public, category: :nails, service: "Nails at Someplace", latitude: '-23.538104', longitude: '-46.219104'
    @private_haircut = FactoryGirl.create :post_private, category: :haircut, service: "My Haircut", latitude: '-23.538101', longitude: '-46.219101'
    @private_nails = FactoryGirl.create :post_private, category: :nails, service: "My Nails", latitude: '-23.538102', longitude: '-46.219102'
    mid_way_place = FactoryGirl.create :place, name: "Midway Place", latitude: "-23.6381", longitude: "-46.3191"
    @mid_way_haircut = FactoryGirl.create :post_public, category: :haircut, service: "Haircut at another neighborhood", place: mid_way_place, latitude: "-23.6381", longitude: "-46.3191"
    far_away_place = FactoryGirl.create :place, latitude: "99.9999", longitude: "99.9999"
    @far_away_haircut = FactoryGirl.create :post_public, category: :haircut, service: "Haircut at another town", place: far_away_place, latitude: "99.9999", longitude: "99.9999"
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
      post "/api/v1/posts?order=closest", post_params, request_headers
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

    it "creates a new post with a caption" do
      user = FactoryGirl.create :user
      post_params = {
        "category" => "haircut",
        "service" => "My beautiful new haircut!",
        "image" => "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/haircut.png",
        "latitude" => 0.0001,
        "longitude" => 0.0001,
        "caption" => "Look how beautiful it is!"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts", post_params, request_headers
      expect(response.status).to eq 201 # created
      expect(Post.last.comments.first.comment).to eq "Look how beautiful it is!" # did it save post to DB?
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
      expect(body["wowed"]).to be false
    end

    it "returns requested wowed post" do
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_public, service: "Some random post"
      wow = Wow.create(user: user, post: post)
      get "/api/v1/posts/#{post.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["id"]).to eq post.id
      expect(body["service"]).to eq "Some random post"
      expect(body["wowed"]).to be true
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
      other_user = FactoryGirl.create :user
      post1 = FactoryGirl.create :post_public, user: user, service: "Post one", created_at: 1.minutes.ago
      post2 = FactoryGirl.create :post_private, user: user, service: "Post two", created_at: 1.seconds.ago
      wow = Wow.create(user: other_user, post: post2)
      get "/api/v1/users/#{user.id}/posts", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(other_user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["posts"][0]["user"]["id"]).to eq user.id
      expect(body["posts"][0]["service"]).to eq "Post two"
      expect(body["posts"][0]["wowed"]).to be true
      expect(body["posts"][1]["user"]["id"]).to eq user.id
      expect(body["posts"][1]["service"]).to eq "Post one"
      expect(body["posts"][1]["wowed"]).to be false
    end

  end

  describe "GET /api/v1/places/:id/posts" do

    it "returns all posts from a place" do
      user = FactoryGirl.create :user
      place = FactoryGirl.create :place
      post1 = FactoryGirl.create :post_public, place: place, service: "Post one"
      post2 = FactoryGirl.create :post_private, place: place, service: "Post two"
      wow = Wow.create(user: user, post: post2)
      get "/api/v1/places/#{place.id}/posts", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
      expect(body["posts"][0]["place"]["id"]).to eq place.id
      expect(body["posts"][0]["service"]).to eq "Post one"
      expect(body["posts"][0]["wowed"]).to be false
      expect(body["posts"][1]["service"]).to eq "Post two"
      expect(body["posts"][1]["wowed"]).to be true
    end

  end

  describe "GET /api/v1/posts" do 

    it "returns all nearby Posts" do
      create_example_posts
      post_params = {
        # "have_place" => true,
        "category" => 0,
        "latitude" => -23.5381,
        "longitude" => -46.2191
      }
      get "/api/v1/posts?distance=10", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
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
      get "/api/v1/posts?distance=10", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
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
      get "/api/v1/posts?distance=10", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
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

    it "returns all nearby Posts by service name" do 
      create_example_posts
      post_params = {
        "category" => 0,
        "latitude" => -23.5381,
        "longitude" => -46.2191,
        "service" => "Haircut at Someplace"
      }
      get "/api/v1/posts", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 1
    end

    it "returns all nearby Posts ordered by distance" do 
      create_example_posts
      post_params = {
        "category" => 0,
        "latitude" => -23.538100,
        "longitude" => -46.219100,
        "order" => "closest"
      }
      get "/api/v1/posts?distance=20", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 3
      expect(body["posts"][2]["id"]).to eq @mid_way_haircut.id
    end

    it "returns all nearby Posts ordered by most wows" do 
      for i in 1..5
         p = FactoryGirl.create :post_private, category: :haircut, service: "Post #{i}", created_at: i.days.ago
         for j in 1..i
          FactoryGirl.create :wow, post: p
         end
      end
      post_params = {
        "category" => 0,
        "latitude" => 0.0001,
        "longitude" => 0.0001,
        "order" => "best"
      }
      get "/api/v1/posts", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 5
      expect(body["posts"][0]["wows"]).to eq 5
      expect(body["posts"][4]["wows"]).to eq 1
    end

    it "returns most wowed posts if there are no nearby posts" do 
      create_example_posts
      post_params = {
        "category" => 0,
        "latitude" => 50.00,
        "longitude" => 50.00
      }
      get "/api/v1/posts?distance=1", post_params, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 4
    end

  end

  # Reports

  describe "POST /api/v1/posts/:id/reports" do

    it "reports a post" do 
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_public
      report = FactoryGirl.create :report, post: post
      report_params = {
        "flag" => "other",
        "explanation" => "Report this test!"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts/#{post.id}/reports", report_params, request_headers
      expect(post.reports.size).to eq 2
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["post"]["id"]).to eq post.id
      expect(body["user"]["id"]).to eq user.id
      expect(body["flag"]).to eq "Other"
      expect(body["explanation"]).to eq "Report this test!"
    end

    it "updates report for same user and post" do
      user = FactoryGirl.create :user
      post = FactoryGirl.create :post_public
      report = FactoryGirl.create :report, post: post, user: user, flag: :other, explanation: nil
      report_params = {
        "flag" => "innapropriate",
        "explanation" => "Report this test, again!"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/posts/#{post.id}/reports", report_params, request_headers
      expect(post.reports.size).to eq 1
      expect(response.status).to eq 201 # nope
      body = JSON.parse(response.body)
      expect(body["flag"]).to eq "Innapropriate"
      expect(body["explanation"]).to eq "Report this test, again!"
    end

  end

  # describe "GET /api/v1/posts/:id/reports" do

  #   it "returns all reports from a post" do 
  #     post = FactoryGirl.create :post_public
  #     report1 = FactoryGirl.create :report, post: post
  #     report2 = FactoryGirl.create :report, post: post
  #     get "/api/v1/posts/#{post.id}/reports", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token }
  #     expect(response.status).to eq 200 # ok
  #     body = JSON.parse(response.body)
  #     expect(body.size).to eq 2
  #   end
    
  # end

  # describe "DELETE /api/v1/posts/:id/reports/:id" do

  #   it "unreport a post" do
  #     post = FactoryGirl.create :post_public
  #     user = FactoryGirl.create :user
  #     report = FactoryGirl.create :report, post: post, user: user
  #     delete "/api/v1/posts/#{post.id}/reports/#{report.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
  #     expect(response.status).to eq 204 # ok, no content
  #     expect(post.reports.size).to eq 0
  #   end
    
  # end

end