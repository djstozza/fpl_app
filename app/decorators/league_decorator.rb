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

    players = Player.where.not(id: self.players.pluck(:id)).where('players.created_at < ?', deadline_time)
    PlayersDecorator.new(players).all_data
  end

  def tradeable_players(out_fpl_team_id, in_fpl_team_id = nil)
    players =
      Player
        .joins('LEFT JOIN leagues_players ON leagues_players.player_id = players.id')
        .joins('LEFT JOIN fpl_teams_players ON fpl_teams_players.player_id = players.id')
        .where(leagues_players: { league_id: id })
        .where.not(fpl_teams_players: { fpl_team_id: fpl_team_id })

    PlayersDecorator.new(players).all_data
  end
end
