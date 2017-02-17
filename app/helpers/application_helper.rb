module ApplicationHelper
  def check_incactive_col(position, stat)
    'inactive' if position.players.where(team_id: @team.id).all? { |player| player.public_send(stat) == 0 }
  end
end
