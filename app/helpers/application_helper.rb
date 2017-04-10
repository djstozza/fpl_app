module ApplicationHelper
  def check_inactive_col(position, stat)
    'inactive' if position.players.where(team_id: @team_decorator.id).all? { |player| player.public_send(stat) == 0 }
  end
end
