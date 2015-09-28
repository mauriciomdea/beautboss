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
      Activity.create(owner: followed, subject: follower)
      post = FactoryGirl.create :post, user: followed
      wow = Wow.create(post: post, user: follower)
      Activity.create(owner: followed, subject: wow)
      comment = Comment.create(post: post, user: follower, comment: "This is just an example comment, please ignore.")
      Activity.create(owner: followed, subject: comment)
      activities = Activity.where(owner: followed)
      serialized_activities = activities.map { |activity| ActivitySerializer.new(activity).as_json(root: false) }
      # puts serialized_activities.to_yaml
    end

    xit "creates notification for following an user" do
      user1 = FactoryGirl.create :user, name: "The Followed"
      user2 = FactoryGirl.create :user, name: "A Follower"
      post "/api/v1/users/#{user1.id}/follow", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user2) }
      expect(response.status).to eq 201 # created
    end

    xit "creates notification for new post from a followed user" do 
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
    end

    it "creates notification for new wow on user's post"

    it "creates notification for new comment on user's post"

  end

end
