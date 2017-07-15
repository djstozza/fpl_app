FactoryGirl.define do
  factory :player, class: Player do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    code { Faker::Number.number(5) }
    team {}
    position {}
    ict_index {}
  end
end
