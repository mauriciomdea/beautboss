require 'rails_helper'

RSpec.describe "Users" do

  describe "Create User" do

    it "creates user from email/password" do 
      user = User.new(name: "Test", email: "test@example.com", password: "12345678")
      user.save
      # puts user.errors.to_yaml
      expect(user.persisted?).to be true
    end

    it "refuses user without name" do 
      user = User.new(email: "test@example.com", password: "12345678")
      user.save
      # puts user.errors.messages.to_s
      expect(user.persisted?).to be false
      expect(user.errors.messages[:name][0]).to eq "can't be blank"
      expect(user.errors.messages[:username][0]).to eq "can't be blank"
    end

    it "refuses user without email" do 
      user = User.new(name: "Test", password: "12345678")
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
      user = User.new(name: "Test", email: "test@example.com", password: "12345678")
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

    it "refuses username with special characters" do 

      user = FactoryGirl.create :user, username: "this_is-4ll0w3d"
      
      user.username = "do not_allow-this" # spaces
      expect(user.valid?).to be false
      expect(user.save).to be false
      expect(user.errors.messages[:username].first).to eq "No special characters, only letters, numbers and underscores"

      user.username = "do.not_allow-this" # points
      expect(user.valid?).to be false
      user.save
      expect(user.errors.messages[:username].first).to eq "No special characters, only letters, numbers and underscores"

      user.username = "do_not_allow-this!" # exclamation marks
      expect(user.valid?).to be false
      user.save
      expect(user.errors.messages[:username].first).to eq "No special characters, only letters, numbers and underscores"

      user.username = "do^not_allow-this" # accents
      expect(user.valid?).to be false
      user.save
      expect(user.errors.messages[:username].first).to eq "No special characters, only letters, numbers and underscores"

      user.username = "do&not_allow-this" # special chars
      expect(user.valid?).to be false
      user.save
      expect(user.errors.messages[:username].first).to eq "No special characters, only letters, numbers and underscores"

    end

    it "deletes all user related data when user is deleted" do 

      user = FactoryGirl.create :user 
      post = FactoryGirl.create :post_public, user: user
      wow1 = FactoryGirl.create :wow, post: post
      act1 = FactoryGirl.create :activity_wow, owner: user, actor: wow1.user, subject: post
      wow2 = FactoryGirl.create :wow, post: post
      act2 = FactoryGirl.create :activity_wow, owner: user, actor: wow2.user, subject: post
      cmt1 = FactoryGirl.create :comment, post: post
      act3 = FactoryGirl.create :activity_comment, owner: user, actor: cmt1.user, subject: post
      cmt2 = FactoryGirl.create :comment, post: post
      act4 = FactoryGirl.create :activity_comment, owner: user, actor: cmt2.user, subject: post

      user.destroy

      expect(User.find_by(id: user.id)).to be nil
      expect(Post.find_by(id: post.id)).to be nil
      expect(Wow.find_by(id: wow1.id)).to be nil
      expect(Wow.find_by(id: wow2.id)).to be nil
      expect(Comment.find_by(id: cmt1.id)).to be nil
      expect(Comment.find_by(id: cmt2.id)).to be nil
      expect(Activity.where(user_id: user.id).count).to be 0
      expect(Activity.where(actor_id: user.id).count).to be 0
      expect(Activity.where(subject: post).count).to be 0

    end

  end

end
