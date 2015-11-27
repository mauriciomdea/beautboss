require 'rails_helper'

RSpec.describe "Devices API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/users/:id/devices" do

    it "receives ios_dev device token for a user" do 
      user = FactoryGirl.create :user
      device_params = {
        "token" => "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890",
        "type" => "ios_dev"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/users/#{user.id}/devices", device_params, request_headers
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["user"]["id"]).to eq user.id
      expect(body["device_type"]).to eq "ios_dev"
      expect(body["device_token"]).to eq "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890"
    end

    it "receives ios device token for a user" do 
      user = FactoryGirl.create :user
      device_params = {
        "token" => "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890",
        "type" => "ios"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/users/#{user.id}/devices", device_params, request_headers
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["user"]["id"]).to eq user.id
      expect(body["device_type"]).to eq "ios"
      expect(body["device_token"]).to eq "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890"
    end

    it "receives android device token for a user" do 
      user = FactoryGirl.create :user
      device_params = {
        "token" => "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890",
        "type" => "android"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/users/#{user.id}/devices", device_params, request_headers
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["user"]["id"]).to eq user.id
      expect(body["device_type"]).to eq "android"
      expect(body["device_token"]).to eq "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890"
    end

    it "refuses invalid device type" do 
      user = FactoryGirl.create :user
      device_params = {
        "token" => "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890",
        "type" => "blackberry"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      post "/api/v1/users/#{user.id}/devices", device_params, request_headers
      expect(response.status).to eq 500 # unprocessable entity
      body = JSON.parse(response.body)
      expect(body["error"]).to eq "'blackberry' is not a valid device_type"
    end

    it "deletes device for a user" do 
      user = FactoryGirl.create :user
      device = FactoryGirl.create :device
      device_params = {
        "type" => device.device_type
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(user)
      }
      delete "/api/v1/users/#{user.id}/devices", device_params, request_headers
      expect(response.status).to eq 204 # ok, no content
    end

  end

end