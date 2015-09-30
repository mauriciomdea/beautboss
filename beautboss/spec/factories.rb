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
    lat "00.00"
    lon "00.00"
    address "Somewhere"
  end

  factory :post do
    caption "Post example"
    image "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png"
    association :user, factory: :user
    association :place, factory: :place
  end

  factory :wow do
    association :user, factory: :user
    association :post, factory: :post
  end

  factory :comment do
    comment "Some trivial comment"
    association :user, factory: :user
    association :post, factory: :post
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
