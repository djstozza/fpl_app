FactoryGirl.define do
  factory :team, class: Team do
    name { Faker::Team.name }
    short_name { Faker::Team.name }
    code { Faker::Number.number(5) }
  end
end
