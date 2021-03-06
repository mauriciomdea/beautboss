require 'rails_helper'

RSpec.describe "Notifications API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "GET /api/v1/users/:id/notifications" do

    it "returns all recent notifications for the user" do 
      followed = FactoryGirl.create :user, name: "The Followed"
      follower = FactoryGirl.create :user, name: "A Follower"
      follower.follow(followed)
      Activity.create(owner: followed, actor: follower, subject: followed, created_at: Time.now.ago(1.day))
      post = FactoryGirl.create :post_public, user: followed
      wow = Wow.create(post: post, user: follower)
      Activity.create(owner: followed, actor: follower, subject: wow, created_at: Time.now.ago(1.hour))
      comment = Comment.create(post: post, user: follower, comment: "This is just an example comment, please ignore.")
      Activity.create(owner: followed, actor: follower, subject: comment, created_at: Time.now.ago(1.minute))
      activities = Activity.where(owner: followed)
      expect(follower.activities.size).to eq 3
      expect(followed.notifications.size).to eq 3
      get "/api/v1/users/#{followed.id}/notifications", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(followed) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 3
      expect(body["notifications"][0]["subject"]).to eq "comment"
      expect(body["notifications"][0]["image"]).to eq post.image
      expect(body["notifications"][1]["subject"]).to eq "wow"
      expect(body["notifications"][1]["image"]).to eq post.image
      expect(body["notifications"][2]["subject"]).to eq "follow"
      expect(body["notifications"][2]["image"]).to eq followed.avatar
    end

    it "returns all recent notifications for the user and mark them as read" do 
      user = FactoryGirl.create :user
      3.times { 
        FactoryGirl.create(:activity_wow, owner: user)
        FactoryGirl.create(:activity_comment, owner: user)
      }
      expect(user.notifications.unread.size).to eq 6 # before reading
      get "/api/v1/users/#{user.id}/notifications?mark_as_read=true", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 6
      expect(user.notifications.unread.size).to eq 0 # after marked as read
    end

    it "returns only the last five unread notifications (limit)" do
      user = FactoryGirl.create(:user)
      10.times { 
        FactoryGirl.create(:activity_wow, owner: user)
        FactoryGirl.create(:activity_comment, owner: user)
      }
      get "/api/v1/users/#{user.id}/notifications?limit=5", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 20
      expect(body["notifications"].size).to eq 5
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
      post = FactoryGirl.create :post_public, user: followed
      post "/api/v1/posts/#{post.id}/wows", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(follower) }
      expect(response.status).to eq 201 # created
      expect(followed.notifications.size).to eq 1
    end

    it "creates notification for new comment on user's post" do 
      followed = FactoryGirl.create :user, name: "The Followed"
      follower = FactoryGirl.create :user, name: "A Follower Who Comments"
      post = FactoryGirl.create :post_public, user: followed
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
