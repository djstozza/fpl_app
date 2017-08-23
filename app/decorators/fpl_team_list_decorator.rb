class FplTeamListDecorator < SimpleDelegator
  def score
    total_score || provisional_score
  end

  def provisional_score
    arr = list_positions.starting.map do |list_position|
      list_position.player.player_fixture_histories.find { |history| history['round'] == round.id }
    end
    return if arr.all? { |x| x.nil? }
    arr.inject(0) { |sum, x| sum + x }
  end
end
