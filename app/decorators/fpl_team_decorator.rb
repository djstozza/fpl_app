class FplTeamDecorator < SimpleDelegator
  POSITION_IDS = { goalkeepers: 1, defenders: 2, midfielders: 3, forwards: 4 }.freeze

  def players_by_position(position:, order: nil)
    players = self.players.where(position_id: POSITION_IDS[position.to_sym])
    order ? players.order(order).reverse : players
  end

  def fpl_team_list_rounds
    return [] if fpl_team_lists.empty?
    RoundsDecorator.new(Round.where(id: fpl_team_lists.pluck(:round_id)))
  end

  def current_fpl_team_list
    return if fpl_team_lists.empty?
    fpl_team_lists.find_by(round_id: fpl_team_list_rounds.current_round.id)
  end

  def current_line_up
    return [] if  current_fpl_team_list.nil?
    ListPositionsDecorator.new(current_fpl_team_list.list_positions).list_position_arr
  end
end
