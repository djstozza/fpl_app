class WaiverPicksDecorator < SimpleDelegator
  def all_data
    order(:pick_number).joins(
      'JOIN players AS in_players ON waiver_picks.in_player_id = in_players.id'
    ).joins(
      'JOIN players AS out_players ON waiver_picks.out_player_id = out_players.id'
    ).joins(
      'JOIN teams AS in_teams ON in_players.team_id = in_teams.id'
    ).joins(
      'JOIN teams AS out_teams ON out_players.team_id = out_teams.id'
    ).joins(
      'JOIN positions ON in_players.position_id = positions.id'
    ).pluck_to_hash(
      :id,
      :pick_number,
      :status,
      :singular_name_short,
      :in_player_id,
      'in_players.first_name as in_first_name',
      'in_players.last_name as in_last_name',
      'in_teams.short_name as in_team_short_name',
      :out_player_id,
      'out_players.first_name as out_first_name',
      'out_players.last_name as out_last_name',
      'out_teams.short_name as out_team_short_name'
    )
  end

  def can_waiver_pick
    return false if round.id == 1
    current_round = Round.current_round
    return false unless round.id == current_round.id
    return false if Time.now > current_round.deadline_time - 2.days
    true
  end
end
