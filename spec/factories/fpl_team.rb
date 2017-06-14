FactoryGirl.define do
  factory :fpl_team, class: FplTeam do
    name { Faker::Team.name }
    user {}
    league {}
  end
end
