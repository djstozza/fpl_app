FactoryGirl.define do
  factory :user, class: User do
    username { Faker::Name.first_name }
    email { Faker::Internet.email }
    password 'abcd1234'
  end
end
