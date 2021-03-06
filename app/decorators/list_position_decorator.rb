class ListPositionDecorator < SimpleDelegator
  def list_positions
    fpl_team_list.list_positions.order(role: :asc, position_id: :desc)
  end

  def substitute_options
    options =
      if list_positions.goalkeepers.include?(__getobj__)
        list_positions.goalkeepers.where.not(player_id: player_id)
      elsif starting?
        list_positions.field_players.where.not(role: 'starting').to_a.delete_if do |list_position|
          @starting_lineup_arr = list_positions.starting.where.not(player_id: player_id).to_a
          @starting_lineup_arr << list_position
          starting_position_count('Forward').zero? || starting_position_count('Midfielder') < 2 ||
          starting_position_count('Defender') < 3
        end
      else
        list_positions.field_players.where.not(player_id: player_id).to_a.delete_if do |list_position|
          @starting_lineup_arr = list_positions.starting.where.not(player: list_position.player).to_a
          @starting_lineup_arr << __getobj__
          starting_position_count('Forward').zero? || starting_position_count('Midfielder') < 2 ||
          starting_position_count('Defender') < 3
        end
      end
    options.map { |option| option.player_id }
  end

  # Not sure whether I'll have to use this or whether event_points will be sufficient
  def scoring_hash
    pfh = player_fixture_history
    {
      id: id,
      role: role,
      position_id: position_id,
      player_id: player_id,
      status: player.status,
      minutes: pfh.nil? ? 0 : pfh['minutes'],
      points: pfh.nil? ? 0 : pfh['total_points'],
      team_id: player.team_id
    }
  end

  private

  def starting_position_count(position_name)
    @starting_lineup_arr.select { |list_position| list_position.position.singular_name == position_name }.count
  end

  def player_fixture_history
    player.player_fixture_histories.find { |pfh| pfh['round'] == fpl_team_list.round_id }
  end

  def minutes
    player_fixture_history ? player_fixture_history['minutes'] : 0
  end

  def points
    player_fixture_history ? player_fixture_history['total_points'] : 0
  end
end
