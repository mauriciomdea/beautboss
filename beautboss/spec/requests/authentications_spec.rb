require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  describe "POST /api/v1/authentications" do

    it "retrieves access token from user email and password" do
      user = FactoryGirl.create :user
      auth_params = {
        "email" => "#{user.email}",
        "password" => "#{user.password}"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/authentications", auth_params, request_headers
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["token"]).not_to be_empty
    end

    it "refuses authentication for wrong email and/or password" do
      auth_params = {
        "email" => nil,
        "password" => nil
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      post "/api/v1/authentications", auth_params, request_headers
      expect(response.status).to eq 404 # not found
    end

  # describe "GET /authentications" do
  #   it "works! (now write some real specs)" do
  #     get authentications_path
  #     expect(response).to have_http_status(200)
  #   end

  end

end
