FactoryGirl.define do
  factory :team, class: Team do
    name { Faker::Name.unique.name }
    short_name { Faker::Name.unique.first_name }
    code { Faker::Number.unique.number(5) }
  end
end
