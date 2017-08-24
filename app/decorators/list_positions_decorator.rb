class ListPositionsDecorator < SimpleDelegator
  def list_position_arr
    order(role: :asc, position_id: :desc)
      .joins(:player)
      .joins(:position)
      .joins('JOIN teams ON teams.id = players.team_id')
      .pluck_to_hash(
        :id,
        :player_id,
        :role,
        :last_name,
        :position_id,
        :singular_name_short,
        :team_id,
        :short_name,
        :status,
        :total_points,
        :player_fixture_histories,
        :event_points
    )
  end
end
