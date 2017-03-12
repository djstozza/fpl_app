require 'sidekiq'
require 'sidekiq-scheduler'
require 'httparty'

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
                      link_url: team['link_url'],
                      strength_overall_home: team['strength_overall_home'],
                      strength_overall_away: team['strength_overall_away'],
                      strength_attack_home: team['strength_attack_home'],
                      strength_attack_away: team['strength_attack_away'],
                      strength_defence_home: team['strength_defence_home'],
                      strength_defence_away: team['strength_defence_away'],
                      team_division: team['team_division'])
    end

    Team.all.each do |team|
      team.update(wins: team.fixtures_won.count,
                  losses: team.fixtures_lost.count,
                  draws: team.fixtures_drawn.count,
                  clean_sheets: team.clean_sheet_fixtures.count,
                  goals_for: team.goals('team_h', 'team_a'),
                  goals_against: team.goals('team_a', 'team_h'),
                  goal_difference: (team.goals('team_h', 'team_a') - team.goals('team_a', 'team_h')),
                  points: (team.fixtures_won.count * 3 + team.fixtures_drawn.count),
                  played: team.fixtures.where(finished: true).count,
                  form: team.current_form)
    end

    Team.all.each do |team|
      team.update(position: (Team.ladder.index(team) + 1))
    end
  end
end
