class ListPositionsDecorator < SimpleDelegator
  def list_position_arr
    order(role: :asc, position_id: :desc).joins(:player).pluck_to_hash(
      :id,
      :player_id,
      :role,
      :last_name,
      :position_id,
      :team_id,
      :status,
      :total_points,
      :player_fixture_histories
    )
    # .collect do |list_position|
    #   ListPositionDecorator.new(list_position).scoring_hash
    # end


    #   .joins(:player).pluck_to_hash(
    #   :id,
    #   :player_id,
    #   :role,
    #   :position_id,
    #   :team_id,
    #   :status,
    #   :event_points
    # )
    # Not sure yet how often event points gets updated. May have to resort to mapping score hash from
    # ListPositionDecorator
  end
end
