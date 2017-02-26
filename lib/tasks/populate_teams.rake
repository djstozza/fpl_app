desc 'populate teams'

namespace :data_seeding do
  task populate_teams: :environment do
    HTTParty.get('https://fantasy.premierleague.com/drf/teams').each do |team|
      fpl_team = Team.find_or_create_by(id: team['id'])
      fpl_team.update(name: team['name'],
                      code: team['code'],
                      short_name: team['short_name'],
                      strength: team['strength'],
                      position: team['position'],
                      played: team['played'],
                      wins: team['win'],
                      losses: team['loss'],
                      draws: team['draw'],
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
