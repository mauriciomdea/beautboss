require 'rails_helper'

RSpec.describe "Newsfeed API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/newsfeed" do

    it "returns newsfeed for authorized user" do

      current_user = FactoryGirl.create :user
      john = FactoryGirl.create :user, name: "John Doe"
      jane = FactoryGirl.create :user, name: "Jane Smith"
      current_user.follow(john)
      current_user.follow(jane)
      for i in 1..3
        FactoryGirl.create :post_public, user: john, service: "Post #{i} from #{john.name}", created_at: (3-i).seconds.ago
        FactoryGirl.create :post_public, user: jane, service: "Post #{i} from #{jane.name}", created_at: (3-i).seconds.ago
        FactoryGirl.create :post_public, service: "Post #{i} from Someone Else", created_at: (3-i).seconds.ago
      end
      get "/api/v1/newsfeed?limit=5", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(current_user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 6
      expect(body["posts"].size).to eq 5
      expect(body["posts"][0]["user"]["id"]).to eq john.id
      expect(body["posts"][0]["service"]).to eq "Post 3 from John Doe"

    end

  end

end
