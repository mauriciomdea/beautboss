require 'rails_helper'

RSpec.describe "Users API v1", type: :request do

  describe "GET /api/v1/users/:id" do
    it "returns a requested user" do
      user = FactoryGirl.create :user, name: "John Doe"
      get "/api/v1/users/#{user.id}", {}, { "Accept" => "application/json" }
      # get api_v1_user(user.id), {}, { "Accept" => "application/json" }
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body["name"]).to eq "John Doe"
    end
  end

  # describe "GET /users" do
  #   it "works! (now write some real specs)" do
  #     get api_users_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

end
