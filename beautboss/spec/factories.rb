FactoryGirl.define do

  factory :user do
    sequence(:name)  { |n| "Robot #{n}" }
    sequence(:email) { |n| "robot#{n}@example.com"}
    password "12345678"
    sequence(:facebook)  { |n| "#{n}" }
  end

  factory :place do
    sequence(:foursquare_id) { |n| "4a00a0bb00a0aa00aa00a0a#{n}" } 
    name "Somewhere Hair Style"
    sequence(:latitude) { |n| "0.000#{n}" }
    sequence(:longitude) { |n| "0.000#{n}" }
    address "Somewhere, SW"
  end

  factory :post do

    association :user, factory: :user
    sequence(:image)  { |n| "http://elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/#{n}.png" }
    sequence(:latitude) { |n| "0.000#{n}" }
    sequence(:longitude) { |n| "0.000#{n}" }
    category { ["haircut", "hairstyle", "colouring", "highlights", "nails", "makeup", "barber"].sample }

    factory :post_public do 
      service "A Haircut"
      association :place, factory: :place
    end

    factory :post_private do 
      service "A Haircut at Home"
    end

  end  

  factory :wow do
    association :user, factory: :user
    association :post, factory: :post_public
  end

  factory :comment do
    comment "Some trivial comment"
    association :user, factory: :user
    association :post, factory: :post_public
  end

  factory :report do
    association :user, factory: :user
    association :post, factory: :post_public
    flag { [:innapropriate, :wrong_location, :closed_or_private, :copyright_infringement, :other].sample }
  end

  factory :activity do
    
    association :owner, factory: :user
    association :actor, factory: :user

    factory :activity_follow do
      association :subject, factory: :user
    end

    factory :activity_wow do
      association :subject, factory: :wow
    end

    factory :activity_comment do
      association :subject, factory: :comment
    end

  end

  factory :device do
    association :user, factory: :user
    platform { ["ios_dev", "ios", "android"].sample }
    endpoint "ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890"
  end

end
