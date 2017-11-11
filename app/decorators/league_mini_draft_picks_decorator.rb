class LeagueMiniDraftPicksDecorator < LeagueDecorator
  def all_non_passed_draft_picks
    mini_draft_picks.order(:pick_number).joins(:fpl_team).joins(
      'JOIN players AS in_players ON mini_draft_picks.in_player_id = in_players.id'
    ).joins(
      'JOIN players AS out_players ON mini_draft_picks.out_player_id = out_players.id'
    ).joins(
      'JOIN teams AS in_teams ON in_players.team_id = in_teams.id'
    ).joins(
      'JOIN teams AS out_teams ON out_players.team_id = out_teams.id'
    ).joins(
      'JOIN positions ON in_players.position_id = positions.id'
    ).pluck_to_hash(
      :id,
      :pick_number,
      :singular_name_short,
      :in_player_id,
      :completed,
      :passed,
      'fpl_teams.name as fpl_team_name',
      'in_players.first_name as in_first_name',
      'in_players.last_name as in_last_name',
      'in_teams.short_name as in_team_short_name',
      :out_player_id,
      'out_players.first_name as out_first_name',
      'out_players.last_name as out_last_name',
      'out_teams.short_name as out_team_short_name'
    )
  end

  def current_draft_pick
    mini_draft_picks.build(pick_number: next_pick_number, fpl_team: next_fpl_team, season: 'summer')
  end

  def next_fpl_team
    return if all_fpl_teams_passed?
    divider = next_pick_number % (2 * fpl_team_count)

    index = divider == 0 ? divider : divider - 1

    if index < fpl_team_count
      fpl_team_arr.reverse[index % fpl_team_count]
    else
      fpl_team_arr[index % fpl_team_count]
    end
  end

  def season
    Time.now > Round::WINTER_MINI_DRAFT_DEALINE ? 'winter' : 'summer'
  end

  def next_pick_number
    round = Round.current_round
    (mini_draft_picks.where(round_id: round.id).order(:pick_number).last&.pick_number || 0) + 1
  end

  def all_fpl_teams_passed?
    fpl_teams.all? { |fpl_team| fpl_team.mini_draft_picks.public_send(season).where(passed: true).any? }
  end

  private

  def fpl_team_arr
    fpl_teams.order(:rank)
  end

  def fpl_team_count
    fpl_team_arr.count
  end
end
