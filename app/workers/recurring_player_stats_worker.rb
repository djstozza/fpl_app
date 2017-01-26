require 'sidekiq'
require 'sidetiq'

class RecurringPlayerStatsWorker
  include HTTParty
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options retry: 2

  recurrence { daily.hour_of_day(18) }

  def perform
    HTTParty.get('https://fantasy.premierleague.com/drf/elements').each do |player|
      fpl_player = Player.find_or_create_by(id: player['id'])
      fpl_player.update(
        first_name: player['first_name'],
        last_name: player['second_name'],
        squad_number: player['squad_number'],
        team_code: player['team_code'],
        photo: player['photo'],
        web_name: player['web_name'],
        status: player['status'],
        code: player['code'],
        news: player['news'],
        now_cost: player['now_cost'],
        chance_of_playing_this_round: player['chance_of_playing_this_round'],
        chance_of_playing_next_round: player['chance_of_playing_next_round'],
        value_form: player['value_form']&.to_d,
        value_season: player['value_season']&.to_d,
        cost_change_start: player['cost_change_start'],
        cost_change_event: player['cost_change_event'],
        cost_change_start_fall: player['cost_change_start_fall'],
        cost_change_event_fall: player['cost_change_event_fall'],
        in_dreamteam: player['in_dreamteam'],
        dreamteam_count: player['dreamteam_count'],
        selected_by_percent: player['selected_by_percent']&.to_d,
        form: player['form']&.to_d,
        transfers_out: player['transfers_out'],
        transfers_in: player['transfers_in'],
        transfers_out_event: player['transfers_out_event'],
        transfers_in_event: player['transfers_in_event'],
        loans_in: player['loans_in'],
        loans_out: player['loans_out'],
        loaned_in: player['loaned_in'],
        loaned_out: player['loaned_out'],
        total_points: player['total_points'],
        event_points: player['event_points'],
        points_per_game: player['points_per_game']&.to_d,
        ep_this: player['ep_this']&.to_d,
        ep_next: player['ep_next']&.to_d,
        special: player['special'],
        minutes: player['minutes'],
        goals_scored: player['goals_scored'],
        goals_conceded: player['goals_conceded'],
        assists: player['assists'],
        clean_sheets: player['clean_sheets'],
        own_goals: player['own_goals'],
        penalties_missed: player['penalties_missed'],
        penalties_saved: player['penalties_saved'],
        yellow_cards: player['yellow_cards'],
        red_cards: player['red_cards'],
        saves: player['saves'],
        bonus: player['bonus'],
        bps: player['bps'],
        influence: player['influence']&.to_d,
        creativity: player['creativity']&.to_d,
        threat: player['threat']&.to_d,
        ict_index: player['ict_index']&.to_d,
        ea_index: player['ea_index'],
        position_id: player['element_type'],
        team_id: player['team']
      )

    HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{fpl_player.id}")['history']
            .each do |player_fixture_history|
      fpl_player_fixture_history = PlayerFixtureHistory.find_or_create_by(id: player_fixture_history['id'])
      fpl_player_fixture_history.update(
        kickoff_time: player_fixture_history['kickoff_time'],
        team_h_score: player_fixture_history['team_h_score'],
        team_a_score: player_fixture_history['team_a_score'],
        was_home: player_fixture_history['was_home'],
        fixture_id: player_fixture_history['fixture'],
        player_id: player_fixture_history['element'],
        round_id: player_fixture_history['round'],
        total_points: player_fixture_history['total_points'],
        value: player_fixture_history['fixture'],
        minutes: player_fixture_history['minutes'],
        total_points: player_fixture_history['total_points'],
        value: player_fixture_history['value'],
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
      end
    end
  end
end
