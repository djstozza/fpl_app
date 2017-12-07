class FplTeamListDecorator < SimpleDelegator
  def score
    total_score || provisional_score || FplTeamList.find_by(round: Round.find_by(is_current: true))&.total_score
  end

  def provisional_score
    arr = list_positions.starting.map do |list_position|
      list_position.player.player_fixture_histories.find { |history| history['round'] == round.id }
    end
    return if arr.any? { |x| x.nil? }
    arr.inject(0) { |sum, x| sum + x['total_points'] }
  end

  def submitted_in_trade_group_count
    InterTeamTradeGroup.submitted.where(in_fpl_team_list_id: id).count
  end

  def declined_out_trade_group_count
    round_id == Round.current_round.id ? InterTeamTradeGroup.declined.where(out_fpl_team_list_id: id).count : 0
  end

  def approved_out_trade_group_count
    round_id == Round.current_round.id ? InterTeamTradeGroup.approved.where(out_fpl_team_list_id: id).count : 0
  end
end
