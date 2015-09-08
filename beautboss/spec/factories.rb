FactoryGirl.define do

  factory :user do
    name "John Doe"
    password "1234"
    email { "#{name.underscore}@example.com" }
  end

end
