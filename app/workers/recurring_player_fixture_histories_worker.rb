require 'sidekiq'
require 'sidekiq-scheduler'

class RecurringPlayerFixtureHistoriesWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    Round.current.fixtures.each do |fixture|
      team_arr.each do |team|
        fixture.public_send(team).players.each do |player|
          player_fixture_history =
            HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history']
                    .find { |pfh| pfh['kickoff_time'] == fixture.kickoff_time && pfh['minutes'] > 0 }
          next unless player_fixture_history && player_fixture_history['minutes'] > 0
          pfh = PlayerFixtureHistory.find_or_create_by(id: player_fixture_history['id'])
          pfh.update(
            team_h_score: player_fixture_history['team_h_score'],
            team_a_score: player_fixture_history['team_a_score'],
            was_home: player_fixture_history['was_home'],
            fixture_id: player_fixture_history['fixture'],
            player_id: player_fixture_history['element'],
            round_id: player_fixture_history['round'],
            total_points: player_fixture_history['total_points'],
            value: player_fixture_history['fixture'],
            minutes: player_fixture_history['minutes'],
            goals_scored: player_fixture_history['goals_scored'],
            assists: player_fixture_history['assists'],
            clean_sheets: player_fixture_history['clean_sheets'],
            goals_conceded: player_fixture_history['goals_conceded'],
            own_goals: player_fixture_history['own_goals'],
            penalties_saved: player_fixture_history['penalties_saved'],
            penalties_missed: player_fixture_history['penalties_missed'],
            yellow_cards: player_fixture_history['yellow_cards'],
            red_cards: player_fixture_history['red_cards'],
            saves: player_fixture_history['saves'],
            bonus: player_fixture_history['bonus'],
            influence: player_fixture_history['influence'],
            creativity: player_fixture_history['creativity'],
            threat: player_fixture_history['threat'],
            ict_index: player_fixture_history['ict_index'],
            ea_index: player_fixture_history['ea_index'],
            open_play_crosses: player_fixture_history['open_play_crosses'],
            big_chances_created: player_fixture_history['big_chances_created'],
            clearances_blocks_interceptions: player_fixture_history['clearances_blocks_interceptions'],
            recoveries: player_fixture_history['recoveries'],
            key_passes: player_fixture_history['key_passes'],
            tackles: player_fixture_history['tackles'],
            winning_goals: player_fixture_history['winning_goals'],
            attempted_passes: player_fixture_history['attempted_passes'],
            penalties_conceded: player_fixture_history['penalties_conceded'],
            big_chances_missed: player_fixture_history['big_chances_missed'],
            errors_leading_to_goal: player_fixture_history['errors_leading_to_goal'],
            errors_leading_to_goal_attempt: player_fixture_history['errors_leading_to_goal_attempt'],
            tackled: player_fixture_history['tackled'],
            offside: player_fixture_history['offside'],
            target_missed: player_fixture_history['target_missed'],
            fouls: player_fixture_history['fouls'],
            dribbles: player_fixture_history['dribbles'],
            opponent_team_id: player_fixture_history['opponent_team']
          )

          player_stats_arr.each do |stat|
            player.update(stat =>  player.player_fixture_histories
                                         .inject(0) { |sum, fix_hist| sum + fix_hist.public_send(stat) })
          end
        end
      end
    end
  end

  private

  def team_arr
    ['home_team', 'away_team']
  end

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