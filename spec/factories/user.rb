FactoryBot.define do
  factory :user, class: User do
    username { Faker::Name.unique.first_name }
    email { Faker::Internet.unique.email }
    password 'abcd1234'
  end
end
