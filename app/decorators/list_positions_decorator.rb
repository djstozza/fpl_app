class ListPositionsDecorator < SimpleDelegator
  def list_position_arr
    order(role: :asc, position_id: :desc).pluck_to_hash(:id, :player_id, :role, :position_id)
  end
end
