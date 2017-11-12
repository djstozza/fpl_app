FactoryBot.define do
  factory :fpl_team, class: FplTeam do
    name { Faker::Name.unique.name }
    association :user, factory: :user
    association :league, factory: :league
  end
end
