require 'sidekiq'
require 'sidetiq'

class RecurringFixtureWorker
  include HTTParty
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options retry: 2

  recurrence { daily.hour_of_day(18) }

  def perform
    HTTParty.get('https://fantasy.premierleague.com/drf/fixtures/').each do |fixture|
      fpl_fixture = Fixture.find_or_create_by(id: fixture['id'])
      fpl_fixture.update(kickoff_time: fixture['kickoff_time'],
                         deadline_time: fixture['deadline_time'],
                         team_h_difficulty: fixture['team_h_difficulty'],
                         team_a_difficulty: fixture['team_a_difficulty'],
                         code: fixture['code'],
                         team_h_score: fixture['team_h_score'],
                         team_a_score: fixture['team_a_score'],
                         round_id: fixture['event'],
                         minutes: fixture['minutes'],
                         team_a_id: fixture['team_a'],
                         team_h_id: fixture['team_h'],
                         started: fixture['started'],
                         finished: fixture['finished'],
                         provisional_start_time: fixture['provisional_start_time'],
                         finished_provisional: fixture['finished_provisional'],
                         round_day: fixture['event_day'])
    end
  end
end
