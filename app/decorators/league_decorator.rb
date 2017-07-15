class LeagueDecorator < SimpleDelegator
  def all_draft_picks
    draft_picks.order(:pick_number).joins(:player).pluck_to_hash(
      :id,
      :pick_number,
      :fpl_team_id,
      :player_id,
      :position_id,
      :team_id,
      :first_name,
      :last_name
    )
  end

  def picked_players
    PlayersDecorator.new(players).all_data
  end

  def unpicked_players
    PlayersDecorator.new(Player.all).all_data - picked_players
  end

  def current_draft_pick
    draft_picks.order(:pick_number).where(player_id: nil).first
  end
end
