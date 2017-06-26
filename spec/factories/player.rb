FactoryGirl.define do
  factory :player, class: Player do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    team {}
    position {}
  end
end
