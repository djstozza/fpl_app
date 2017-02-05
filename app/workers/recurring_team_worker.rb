require 'sidekiq'

class RecurringTeamWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
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

Sidekiq::Cron::Job.create(name: 'RecurringTeamWorker - every day at 12pm UTC',
                          cron: '00 12 * * *',
                          class: 'RecurringTeamWorker')
