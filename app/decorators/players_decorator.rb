class PlayersDecorator < SimpleDelegator
  def all_data
    pluck_to_hash(
      :id,
      :first_name,
      :last_name,
      :code,
      :news,
      :chance_of_playing_this_round,
      :chance_of_playing_next_round,
      :in_dreamteam,
      :dreamteam_count,
      :form,
      :minutes,
      :goals_scored,
      :assists,
      :clean_sheets,
      :goals_conceded,
      :own_goals,
      :penalties_saved,
      :penalties_missed,
      :yellow_cards,
      :red_cards,
      :saves,
      :bonus,
      :influence,
      :creativity,
      :threat,
      :ict_index,
      :position_id,
      :team_id,
      :open_play_crosses,
      :big_chances_created,
      :clearances_blocks_interceptions,
      :recoveries,
      :key_passes,
      :tackles,
      :winning_goals,
      :dribbles,
      :fouls,
      :errors_leading_to_goal,
      :offside,
      :target_missed,
      :points_per_game,
      :total_points
    )
  end
end
