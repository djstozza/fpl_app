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

  def fpl_team_list_arr
    fpl_teams
      .joins(:fpl_team_lists)
      .where.not(fpl_team_lists: { rank: nil })
      .order(:name, 'fpl_team_lists.round_id')
      .pluck_to_hash(
        :name,
        'fpl_teams.id AS team_id',
        :round_id,
        :overall_rank,
        'fpl_team_lists.total_score AS list_score',
        'fpl_team_lists.rank AS list_rank'
      ).group_by{ |b| b[:name] }
      .to_a
  end
end
