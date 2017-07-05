class ListPositionsDecorator < SimpleDelegator
  def list_position_arr
    order(role: :asc, position_id: :desc).joins(:player).pluck_to_hash(
      :id,
      :player_id,
      :role,
      :position_id,
      :team_id,
      :status
    )
  end
end
