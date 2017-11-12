FactoryBot.define do
  factory :round, class: Round do
    name { 'Gameweek 1' }
    deadline_time { 7.days.from_now }
    data_checked { false }
    is_current { true }
    is_previous { false }
    is_next { false }
    mini_draft { nil }
  end
end
