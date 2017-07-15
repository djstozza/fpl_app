class WaiverPicksDecorator < SimpleDelegator
  def all_data
    order(:pick_number).joins(:player).pluck_to_hash(
      :id,
      :pick_number,
      :list_position_id,
      :league_id,
      :team_id,
      :status,
      :round_id,
      :player_id,
      :position_id,
      :last_name
    )
  end
end
