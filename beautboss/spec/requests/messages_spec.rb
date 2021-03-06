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
      expect(sender.messages_sent.size).to eq 1
      expect(receiver.messages_received.size).to eq 1
      expect(receiver.notifications.size).to eq 1
      expect(response.status).to eq 201 # created
      body = JSON.parse(response.body)
      expect(body["message"]).to eq "Hello World!"
      expect(body["user"]["id"]).to eq receiver.id
      expect(body["sender"]["id"]).to eq sender.id
    end

    it "does not send a message to an user who blocked sender" do 
      sender = FactoryGirl.create :user, name: "Sender"
      receiver = FactoryGirl.create :user, name: "Receiver"
      receiver.block(sender)
      message_params = {
        "message" => "Hello World!"
      }.to_json
      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "HTTP_TOKEN" => valid_auth_token(sender)
      }
      post "/api/v1/users/#{receiver.id}/messages", message_params, request_headers
      expect(receiver.messages.size).to eq 0
      expect(response.status).to eq 404 # created
    end

  end

  describe "GET /api/v1/users/:id/messages" do

    it "gets messages for current user" do 
      user = FactoryGirl.create :user
      friend = FactoryGirl.create :user, name: "My Friend"
      troll = FactoryGirl.create :user, name: "Internet Troll"
      user.block(troll)
      message1 = FactoryGirl.create :message, user: user, sender: friend, message: "First message", created_at: DateTime.now-3
      message2 = FactoryGirl.create :message, user: user, sender: friend, message: "Last message", created_at: DateTime.now-2
      # message3 = FactoryGirl.create :message, user: user, sender: troll
      message4 = FactoryGirl.create :message, user: user, created_at: DateTime.now-1
      get "/api/v1/users/#{user.id}/messages", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(user.messages.size).to eq 3
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["latest_messages"].size).to eq 2
      expect(body["latest_messages"][0]["sender"]["id"]).to eq message4.sender_id
      expect(body["latest_messages"][1]["sender"]["id"]).to eq friend.id
      expect(body["latest_messages"][1]["id"]).to eq message2.id
    end

    xit "gets messages from an user" do 
    end

  end

  describe "GET /api/v1/users/:id/messages/:id" do

    it "returns requested message" do 
      user = FactoryGirl.create :user
      message = FactoryGirl.create :message, user: user
      get "/api/v1/users/#{user.id}/messages/#{message.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      expect(body["id"]).to eq message.id
      expect(body["user"]["id"]).to eq user.id
      expect(body["sender"]["id"]).to eq message.sender_id
      expect(body["message"]).to eq message.message
      expect(body["read"]).to eq false
    end

  end

  describe "PUT/PATCH /api/v1/users/:id/messages/:id" do

    it "marks a message and all messages before it as read" do 
      user = FactoryGirl.create :user
      message1 = FactoryGirl.create :message, user: user, created_at: DateTime.now-1
      acivity1 = FactoryGirl.create :activity, owner: user, actor: message1.user, subject: message1, created_at: DateTime.now-1
      message2 = FactoryGirl.create :message, user: user, created_at: DateTime.now
      acivity2 = FactoryGirl.create :activity, owner: user, actor: message2.user, subject: message2, created_at: DateTime.now
      put "/api/v1/users/#{user.id}/messages/#{message2.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 200 # ok
      expect(user.messages_received.size).to eq 2
      body = JSON.parse(response.body)
      expect(body["count"]).to eq 2
    end

    # xit "marks message as unread" do 
    # end 

  end

  describe "DELETE /api/v1/users/:id/messages/:id" do

    it "deletes a message" do 
      user = FactoryGirl.create :user
      message = FactoryGirl.create :message, sender: user
      delete "/api/v1/users/#{message.user.id}/messages/#{message.id}", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(user) }
      expect(response.status).to eq 204 # ok, no content
      expect(user.messages_sent.size).to eq 0
      expect(message.user.messages.size).to eq 0
    end

  end

end
