require 'sidekiq'
require 'sidekiq-scheduler'

class RecurringPlayerFixtureHistoriesWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    round_id = Round.current.id
    Player.all.each do |player|
      pfh = HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history']
                    .find { |pfh| pfh['round'] == round_id && pfh['minutes'] > 0 }
      next unless pfh

      player_fixture_history = PlayerFixtureHistory.find_or_create_by(id: pfh['id'])
      player_fixture_history.update(
        team_h_score: pfh['team_h_score'],
        team_a_score: pfh['team_a_score'],
        was_home: pfh['was_home'],
        fixture_id: pfh['fixture'],
        player_id: pfh['element'],
        round_id: pfh['round'],
        total_points: pfh['total_points'],
        value: pfh['fixture'],
        minutes: pfh['minutes'],
        goals_scored: pfh['goals_scored'],
        assists: pfh['assists'],
        clean_sheets: pfh['clean_sheets'],
        goals_conceded: pfh['goals_conceded'],
        own_goals: pfh['own_goals'],
        penalties_saved: pfh['penalties_saved'],
        penalties_missed: pfh['penalties_missed'],
        yellow_cards: pfh['yellow_cards'],
        red_cards: pfh['red_cards'],
        saves: pfh['saves'],
        bonus: pfh['bonus'],
        influence: pfh['influence'],
        creativity: pfh['creativity'],
        threat: pfh['threat'],
        ict_index: pfh['ict_index'],
        ea_index: pfh['ea_index'],
        open_play_crosses: pfh['open_play_crosses'],
        big_chances_created: pfh['big_chances_created'],
        clearances_blocks_interceptions: pfh['clearances_blocks_interceptions'],
        recoveries: pfh['recoveries'],
        key_passes: pfh['key_passes'],
        tackles: pfh['tackles'],
        winning_goals: pfh['winning_goals'],
        attempted_passes: pfh['attempted_passes'],
        penalties_conceded: pfh['penalties_conceded'],
        big_chances_missed: pfh['big_chances_missed'],
        errors_leading_to_goal: pfh['errors_leading_to_goal'],
        errors_leading_to_goal_attempt: pfh['errors_leading_to_goal_attempt'],
        tackled: pfh['tackled'],
        offside: pfh['offside'],
        target_missed: pfh['target_missed'],
        fouls: pfh['fouls'],
        dribbles: pfh['dribbles'],
        opponent_team_id: pfh['opponent_team']
      )

      player_stats_arr.each do |stat|
        player.update(stat =>  player.player_fixture_histories
                                     .inject(0) { |sum, fix_hist| sum + fix_hist.public_send(stat) })
      end
    end
  end

  private

  def player_stats_arr
    %w(open_play_crosses
       big_chances_created
       clearances_blocks_interceptions
       recoveries
       key_passes
       tackles
       winning_goals
       dribbles
       fouls
       errors_leading_to_goal
       big_chances_missed
       offside
       attempted_passes
       target_missed)
  end
end
