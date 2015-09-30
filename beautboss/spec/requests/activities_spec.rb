require 'rails_helper'

RSpec.describe "Activities API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "GET /api/v1/users/:id/activities" do

    it "returns all recent activities for the user" do 
      followed = FactoryGirl.create :user, name: "The Followed"
      follower = FactoryGirl.create :user, name: "A Follower"
      follower.follow(followed)
      Activity.create(owner: followed, actor: follower, subject: followed)
      post = FactoryGirl.create :post, user: followed
      wow = Wow.create(post: post, user: follower)
      Activity.create(owner: followed, actor: follower, subject: wow)
      comment = Comment.create(post: post, user: follower, comment: "This is just an example comment, please ignore.")
      Activity.create(owner: followed, actor: follower, subject: comment)
      activities = Activity.where(owner: followed)
      expect(follower.activities.size).to eq 3
      expect(followed.notifications.size).to eq 3
      get "/api/v1/users/#{followed.id}/notifications", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(followed) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body.size).to eq 3
    end

    it "returns only the last five notifications (limit)" do
      user = FactoryGirl.create(:user)
      10.times { 
        FactoryGirl.create(:activity_wow, owner: user)
        FactoryGirl.create(:activity_comment, owner: user)
      }
      get "/api/v1/users/#{user.id}/notifications?limit=5", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body.size).to eq 5
    end

    it "creates notification for following an user" do
      followed = FactoryGirl.create :user, name: "The Followed"
      follower = FactoryGirl.create :user, name: "A Follower"
      post "/api/v1/users/#{followed.id}/follow", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(follower) }
      expect(response.status).to eq 201 # created
      expect(followed.notifications.size).to eq 1
    end

    # xit "creates notification for new post from a followed user" do 
    #   user = FactoryGirl.create :user
    #   place = FactoryGirl.create :place
    #   post_params = {
    #     "caption" => "Post example",
    #     "image" => "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
    #     "place_id" => place.id
    #   }.to_json
    #   request_headers = {
    #     "Accept" => "application/json",
    #     "Content-Type" => "application/json",
    #     "HTTP_TOKEN" => valid_auth_token(user)
    #   }
    #   post "/api/v1/posts", post_params, request_headers
    #   expect(response.status).to eq 201 # created
    # end

    it "creates notification for new wow on user's post" do 
      followed = FactoryGirl.create :user, name: "The Followed"
      follower = FactoryGirl.create :user, name: "A Follower Who Wows"
      post = FactoryGirl.create :post, user: followed
      post "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(follower) }
      expect(response.status).to eq 201 # created
      expect(followed.notifications.size).to eq 1
    end

    it "creates notification for new comment on user's post" do 
      followed = FactoryGirl.create :user, name: "The Followed"
      follower = FactoryGirl.create :user, name: "A Follower Who Comments"
      post = FactoryGirl.create :post, user: followed
      comment_params = {
        "comment" => "A trivial comment"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(follower)
      }
      post "/api/v1/posts/#{post.id}/comments", comment_params, request_headers
      expect(response.status).to eq 201 # created
      expect(followed.notifications.size).to eq 1
    end

  end

end
