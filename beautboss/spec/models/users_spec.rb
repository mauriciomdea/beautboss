require 'rails_helper'

RSpec.describe "Users" do

  describe "Create User" do

    it "generates unique username for new user" do
      u1 = FactoryGirl.create :user, name: "John Doe"
      u2 = FactoryGirl.create :user, name: "John Doe"
      u3 = FactoryGirl.create :user, name: "John Doe"
      u4 = FactoryGirl.create :user, name: "John Doe"
      expect(User.find(u1.id).username).to eq "john_doe"
      expect(User.find(u2.id).username).to eq "john_doe1"
      expect(User.find(u3.id).username).to eq "john_doe12"
      expect(User.find(u4.id).username).to eq "john_doe123"
    end

  end

end
