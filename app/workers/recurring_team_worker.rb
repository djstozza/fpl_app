require 'sidekiq'

class RecurringTeamWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

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

    HTTParty.get('https://fantasy.premierleague.com/drf/teams').each do |team|
      fpl_team = Team.find_or_create_by(id: team['id'])
      fpl_team.update(name: team['name'],
                      code: team['code'],
                      short_name: team['short_name'],
                      strength: team['strength'],
                      position: team['position'],
                      played: team['played'],
                      win: team['win'],
                      loss: team['loss'],
                      draw: team['draw'],
                      points: team['points'],
                      form: team['form'],
                      link_url: team['link_url'],
                      strength_overall_home: team['strength_overall_home'],
                      strength_overall_away: team['strength_overall_away'],
                      strength_attack_home: team['strength_attack_home'],
                      strength_attack_away: team['strength_attack_away'],
                      strength_defence_home: team['strength_defence_home'],
                      strength_defence_away: team['strength_defence_away'],
                      team_division: team['team_division'])
    end
  end
end

Sidekiq::Cron::Job.create(name: 'RecurringTeamWorker - every 3min between 11pm and 9am',
                          cron: '00-59/3 0-9,23 * * * *',
                          class: 'RecurringTeamWorker')
