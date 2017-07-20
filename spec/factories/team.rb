FactoryGirl.define do
  factory :team, class: Team do
    name { Faker::Team.unique.name }
    short_name { Faker::Team.unique.name }
    code { Faker::Number.unique.number(5) }
  end
end
