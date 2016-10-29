require 'rails_helper'

RSpec.describe "Messages API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/users/:id/messages" do

    xit "sends a message to an user" do 
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
