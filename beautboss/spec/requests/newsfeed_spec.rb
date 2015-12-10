require 'rails_helper'

RSpec.describe "Newsfeed API v1", type: :request do

  def valid_auth_token(user = FactoryGirl.create(:user))
    Token.get_token(user, 1)
  end

  describe "POST /api/v1/newsfeed" do

    it "returns newsfeed (all news) for a user" do 

      # setup
      dani = FactoryGirl.create :user, name: "Daniela Citro" # current logged user
      # Mary wowed Female Haircut @ Beau London
      mary = FactoryGirl.create :user, name: "Mary Parham"
      post1 = FactoryGirl.create :post_public, category: :haircut, place: FactoryGirl.create(:place, name: "Beau London"), service: "Female Haircut", created_at: 21.hours.ago
      Activity.create(owner: post1.user, actor: mary, subject: FactoryGirl.create(:wow, post: post1, user: mary), created_at: 21.hours.ago)
      # Emma wowed & commented Short Female Haircut @ Studio Path
      emma = FactoryGirl.create :user, name: "Emma West"
      post2 = FactoryGirl.create :post_public, category: :haircut, place: FactoryGirl.create(:place, name: "Studio Path"), service: "Short Female Haircut", created_at: 48.hours.ago
      Activity.create(owner: post2.user, actor: emma, subject: FactoryGirl.create(:wow, post: post2, user: emma), created_at: 48.hours.ago)
      Activity.create(owner: post2.user, actor: emma, subject: FactoryGirl.create(:comment, post: post2, user: emma), created_at: 48.hours.ago)
      # Beth wowed & registered Sombre Hairlights @ Taylor London
      beth = FactoryGirl.create :user, name: "Bethan Spice"
      post3 = FactoryGirl.create :post_public, category: :highlights, user: beth, place: FactoryGirl.create(:place, name: "Taylor Taylor London"), service: "Sombre Hairlights", created_at: 49.hours.ago
      Activity.create(owner: post3.user, actor: beth, subject: post3, created_at: 49.hours.ago)
      # Anna wowed Short Female Haircut @ Shoreditch Spa
      anna = FactoryGirl.create :user, name: "Annabelle Charlier"
      post4 = FactoryGirl.create :post_public, category: :haircut, place: FactoryGirl.create(:place, name: "The Shoreditch Spa"), service: "Short Female Haircut", created_at: 96.hours.ago
      Activity.create(owner: post1.user, actor: anna, subject: FactoryGirl.create(:wow, post: post4, user: anna), created_at: 96.hours.ago)
      # Extra
      post5 = FactoryGirl.create :post_private, category: :highlights, service: "Extra", created_at: 127.hours.ago
      Activity.create(owner: post5.user, actor: post5.user, subject: post5, created_at: 127.hours.ago)
      # Following
      dani.follow(mary)
      Activity.create(owner: mary, actor: dani, subject: mary)
      dani.follow(emma)
      Activity.create(owner: emma, actor: dani, subject: emma)
      dani.follow(beth)
      Activity.create(owner: beth, actor: dani, subject: beth)
      dani.follow(anna)
      Activity.create(owner: anna, actor: dani, subject: anna)
      # request
      get "/api/v1/newsfeed/all", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(dani) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      # puts body.to_yaml
      expect(body["count"]).to eq 5
      expect(body["news"][0]["user"]["id"]).to eq mary.id
      expect(body["news"][0]["subject"]).to eq "wow"
      expect(body["news"][0]["post"]["service"]).to eq "Female Haircut"
      expect(body["news"][0]["post"]["place"]["name"]).to eq "Beau London"
      expect(body["news"][3]["user"]["id"]).to eq beth.id
      expect(body["news"][3]["post"]["place"]["name"]).to eq "Taylor Taylor London"

    end

    it "returns newsfeed (registers) for a user" do

      current_user = FactoryGirl.create :user
      john = FactoryGirl.create :user, name: "John Doe"
      jane = FactoryGirl.create :user, name: "Jane Smith"
      place = FactoryGirl.create :place, name: "The Saloon"
      current_user.follow(john)
      current_user.follow(jane)
      FactoryGirl.create :post_public, user: john, service: "Post from #{john.name}", created_at: 2.minutes.ago
      FactoryGirl.create :post_private, place: place, user: jane, service: "Post from #{jane.name}", created_at: 1.minutes.ago
      FactoryGirl.create :post_public, service: "Post from Someone Else", created_at: 1.minutes.ago
      Wow.create(post: Post.first, user: current_user)
      get "/api/v1/newsfeed/registers?limit=2", {}, { "Accept" => "application/json", "HTTP_TOKEN" => valid_auth_token(current_user) }
      expect(response.status).to eq 200 # ok
      body = JSON.parse(response.body)
      # puts body.to_yaml
      expect(body["count"]).to eq 2
      expect(body["posts"].size).to eq 2
      expect(body["posts"][0]["user"]["id"]).to eq jane.id
      expect(body["posts"][0]["place"]["id"]).to eq place.id
      expect(body["posts"][0]["service"]).to eq "Post from Jane Smith"
      expect(body["posts"][0]["wowed"]).to eq false
      expect(body["posts"][1]["service"]).to eq "Post from John Doe"
      expect(body["posts"][1]["wowed"]).to eq true

    end

  end

end
