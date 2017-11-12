FactoryBot.define do
  factory :league, class: League do
    name { Faker::GameOfThrones.house }
    code { SecureRandom.hex(6) }
    association :commissioner, factory: :user
  end
end
