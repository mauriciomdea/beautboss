FactoryGirl.define do

  factory :user do
    # name "John Doe"
    # email { "#{name.underscore}@example.com" }
    sequence(:name)  { |n| "Robot #{n}" }
    sequence(:email) { |n| "robot#{n}@example.com"}
    password "1234"
  end

  factory :place do
    name "Somewhere Hair Style"
  end

  factory :post do
    caption "Post example"
    image "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png"
    association :user, factory: :user
    association :place, factory: :place
  end

end
