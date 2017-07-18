class WaiverPicksDecorator < SimpleDelegator
  def all_data
    order(:pick_number).map do |waiver_pick|
      {
        id: waiver_pick.id,
        in_player_id: waiver_pick.in_player_id,
        out_player_id: waiver_pick.out_player_id,
        status: waiver_pick.status,
        pick_number: waiver_pick.pick_number,
        in_last_name: waiver_pick.in_player.last_name,
        in_team_short_name: waiver_pick.in_player.team.short_name,
        out_last_name: waiver_pick.out_player.last_name,
        out_team_short_name: waiver_pick.out_player.team.short_name,
        position: waiver_pick.in_player.position.singular_name_short
      }
    end
  end

  def can_waiver_pick
    return false if round.id == 1
    current_round = RoundsDecorator.new(Round.all).current_round
    return false unless round.id == current_round.id
    return false if Time.now > current_round.deadline_time - 2.days
    true
  end
end
