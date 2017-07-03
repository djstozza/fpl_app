class FplTeamDecorator < SimpleDelegator
  POSITION_IDS = { goalkeepers: 1, defenders: 2, midfielders: 3, forwards: 4 }.freeze

  def players_by_position(position:, order: nil)
    players = self.players.where(position_id: POSITION_IDS[position.to_sym])
    order ? players.order(order).reverse : players
  end
end
