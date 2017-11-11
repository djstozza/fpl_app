class LeagueDecorator < SimpleDelegator
  def picked_players
    PlayersDecorator.new(players).all_data
  end

  def unpicked_players
    deadline_time =
      if Time.now < Round::SUMMER_MINI_DRAFT_DEADLINE
        Round.first.deadline_time
      elsif Time.now < Round::WINTER_MINI_DRAFT_DEALINE
        Round::SUMMER_MINI_DRAFT_DEADLINE
      else
        Round::WINTER_MINI_DRAFT_DEALINE
      end

    PlayersDecorator.new(
      Player.where.not(id: players.pluck(:id)).where('players.created_at < ?', deadline_time)
    ).all_data
  end
end
