FactoryGirl.define do
  factory :fpl_team, class: FplTeam do
    name { Faker::Team.unique.name }
    user {}
    league {}
  end
end
