FactoryGirl.define do
  factory :league, class: League do
    name { Faker::GameOfThrones.house }
    code { SecureRandom.hex(6) }
    commissioner {}
  end
end
