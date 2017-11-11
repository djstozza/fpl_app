class LeagueDraftPicksDecorator < LeagueDecorator
  def all_draft_picks
    draft_picks.order(:pick_number).includes(:player, :fpl_team, player: [:team, :position]).pluck_to_hash(
      :id,
      :pick_number,
      :fpl_team_id,
      'fpl_teams.name as fpl_team_name',
      :player_id,
      :position_id,
      :singular_name_short,
      :team_id,
      :short_name,
      'teams.name as team_name',
      :first_name,
      :last_name
    )
  end

  def current_draft_pick
    draft_picks.order(:pick_number).where(player_id: nil).first
  end
end
