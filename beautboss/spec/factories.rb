FactoryGirl.define do

  factory :user do
    # name "John Doe"
    # email { "#{name.underscore}@example.com" }
    sequence(:name)  { |n| "Robot #{n}" }
    sequence(:email) { |n| "robot#{n}@example.com"}
    password "1234"
  end

  factory :place do
    sequence(:foursquare_id)
    name "Somewhere Hair Style"
    lat { |n| "00.0#{n}" }
    lon { |n| "00.0#{n}" }
    address "Somewhere"
  end

  factory :post do

    factory :post_public do 
      service "A Haircut"
      category { ["haircut", "hairstyle", "colouring", "highlights", "nails", "makeup"].sample }
      lat { |n| "00.0#{n}".to_f }
      lon { |n| "00.0#{n}".to_f }
      sequence(:image)  { |n| "http://elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/#{n}.png" }
      association :user, factory: :user
      association :place, factory: :place
    end

    factory :post_private do 
      service "A Haircut at Home"
      category { ["haircut", "hairstyle", "colouring", "highlights", "nails", "makeup"].sample }
      lat { |n| "00.0#{n}" }
      lon { |n| "00.0#{n}" }
      sequence(:image)  { |n| "http://elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/#{n}.png" }
      association :user, factory: :user
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

end
