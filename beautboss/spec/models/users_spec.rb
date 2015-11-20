require 'rails_helper'

RSpec.describe "Users" do

  describe "Create User" do

    it "creates user from email/password" do 
      user = User.new(name: "Test", email: "test@example.com", password: "1234")
      user.save
      # puts user.errors.to_yaml
      expect(user.persisted?).to be true
    end

    it "refuses user without name" do 
      user = User.new(email: "test@example.com", password: "1234")
      user.save
      # puts user.errors.messages.to_s
      expect(user.persisted?).to be false
      expect(user.errors.messages[:name][0]).to eq "can't be blank"
      expect(user.errors.messages[:username][0]).to eq "can't be blank"
    end

    it "refuses user without email" do 
      user = User.new(name: "Test", password: "1234")
      user.save
      # puts user.errors.messages.to_s
      expect(user.persisted?).to be false
      expect(user.errors.messages[:email][0]).to eq "can't be blank"
    end

    it "refuses user without password" do 
      user = User.new(name: "Test", email: "test@example.com")
      user.save
      # puts user.errors.messages.to_s
      expect(user.persisted?).to be false
      expect(user.errors.messages[:password][0]).to eq "can't be blank"
    end

    it "refuses user with existing email" do 
      FactoryGirl.create :user, email: "test@example.com"
      user = User.new(name: "Test", email: "test@example.com", password: "1234")
      user.save
      expect(user.persisted?).to be false
      expect(user.errors.messages[:email][0]).to eq "has already been taken"
    end

    it "creates user from facebook with email" do 
      user = User.new(name: "Test", email: "test@example.com", facebook: "01010101")
      user.save
      expect(user.persisted?).to be true
    end

    it "creates user from facebook without email" do 
      profile = FbGraph2::User.new(10153500647048444, {name: "Johnny Test"})
      user = User.from_facebook(profile)
      user.save
      expect(user.persisted?).to be true
      expect(user.name).to eq "Johnny Test"
    end

    it "updates already registered user from facebook" do 
      user_before = FactoryGirl.create :user, email: "test@example.com", facebook: nil
      profile = FbGraph2::User.new(10153500647048444, {name: "Johnny Test", email: "test@example.com"})
      user_after = User.from_facebook(profile)
      expect(user_after.save).to be true
      expect(user_after.id).to eq user_before.id
      expect(user_after.facebook).to eq "10153500647048444"
      expect(user_after.name).to eq "Johnny Test"
      expect(user_after.email).to eq "test@example.com"
    end

    it "generates unique username for new user" do
      u1 = FactoryGirl.create :user, name: "Johnny Test"
      u2 = FactoryGirl.create :user, name: "Johnny Test"
      u3 = FactoryGirl.create :user, name: "Johnny Test"
      u4 = FactoryGirl.create :user, name: "Johnny Test"
      expect(User.find(u1.id).username).to eq "johnny_test"
      expect(User.find(u2.id).username).to eq "johnny_test1"
      expect(User.find(u3.id).username).to eq "johnny_test12"
      expect(User.find(u4.id).username).to eq "johnny_test123"
    end

  end

end
