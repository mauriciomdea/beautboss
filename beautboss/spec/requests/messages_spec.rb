require 'rails_helper'

RSpec.describe "Messages API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/users/:id/messages" do

    it "sends a message to an user" do 
      sender = FactoryGirl.create :user, name: "Sender"
      receiver = FactoryGirl.create :user, name: "Receiver"
      message_params = {
        "message" => "Hello World!"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(sender)
      }
      post "/api/v1/users/#{receiver.id}/messages", message_params, request_headers
      expect(receiver.messages.size).to eq 1
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["message"]).to eq "Hello World!"
      expect(body["user"]["id"]).to eq receiver.id
      expect(body["sender"]["id"]).to eq sender.id
      # expect(body["read"]).to eq 0
    end

    xit "does not send a message to an user who blocked sender" do 
    end

  end

  describe "GET /api/v1/users/:id/messages" do

    xit "gets messages for current user" do 
    end

    xit "gets messages from an user" do 
    end

  end

  describe "GET /api/v1/users/:id/messages/:id" do

    xit "get specific message" do 
    end

  end

  describe "PUT/PATCH /api/v1/users/:id/messages/:id" do

    xit "marks message as read" do 
    end

    xit "marks message as unread" do 
    end 

  end

  describe "DELETE /api/v1/users/:id/messages/:id" do

    xit "deletes a message" do 
    end

  end

end
