desc 'Populate players'

namespace :data_seeding do
  task populate_players: :environment do
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
    end

    Player.all.each do |player|
      pfhs = HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history']
                     .select { |pfh| pfh['minutes'] > 0 }
      next unless pfhs

      player_stats_arr.each do |stat|
        player.update(stat =>  pfhs.inject(0) { |sum, pfh| sum + pfh[stat] })
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
