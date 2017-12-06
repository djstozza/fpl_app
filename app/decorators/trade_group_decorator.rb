class TradeGroupDecorator < SimpleDelegator
  def in_players_tradeable
    out_fpl_team = self.out_fpl_team_list.fpl_team
    # round = Round.current_round
    players =
      if in_fpl_team_list_id
        in_fpl_team = self.in_fpl_team_list.fpl_team
        Player
          .joins('LEFT JOIN fpl_teams_players ON fpl_teams_players.player_id = players.id')
          .joins('LEFT JOIN fpl_teams ON fpl_teams_players.fpl_team_id = fpl_teams.id')
          .joins('LEFT JOIN fpl_team_lists ON fpl_team_lists.fpl_team_id = fpl_teams.id')
          .where(fpl_teams_players: { fpl_team_id: in_fpl_team.id }, fpl_team_lists: { id: in_fpl_team_list.id })
          .where.not(id: in_players.map(&:id))
      else
        Player
          .joins('LEFT JOIN leagues_players ON leagues_players.player_id = players.id')
          .joins('LEFT JOIN fpl_teams_players ON fpl_teams_players.player_id = players.id')
          .joins('LEFT JOIN fpl_teams AS fpl_teams ON fpl_teams_players.fpl_team_id = fpl_teams.id')
          .joins('LEFT JOIN fpl_team_lists ON fpl_team_lists.fpl_team_id = fpl_teams.id')
          .joins('LEFT JOIN rounds ON fpl_team_lists.round_id = rounds.id')
          .where(leagues_players: { league_id: out_fpl_team.league_id })
          .where(fpl_team_lists: { round_id: self.round_id })
          .where.not(fpl_teams_players: { fpl_team_id: out_fpl_team.id })
      end

    players
      .joins(:team)
      .joins('JOIN positions ON players.position_id = positions.id')
      .pluck_to_hash(
        'players.id AS in_player_id',
        'fpl_teams.id AS in_fpl_team_id',
        'fpl_teams.name AS in_fpl_team_name',
        'fpl_team_lists.id AS in_fpl_team_list_id',
        :singular_name_short,
        :last_name,
        :status,
        :event_points,
        :total_points,
        :short_name
      ).uniq
  end

  def out_players_tradeable
    out_fpl_team = self.out_fpl_team_list.fpl_team
    id = self.id
    print id

    Player
      .joins(:team)
      .joins('LEFT JOIN fpl_teams_players ON fpl_teams_players.player_id = players.id')
      .joins('LEFT JOIN fpl_teams ON fpl_teams_players.fpl_team_id = fpl_teams.id')
      .joins('JOIN positions ON players.position_id = positions.id')
      .where(fpl_teams_players: { fpl_team_id: out_fpl_team.id })
      .where.not(id: out_players.map(&:id))
      .order(position_id: :desc)
      .pluck_to_hash(
        'players.id AS out_player_id',
        :singular_name_short,
        :last_name,
        :status,
        :event_points,
        :total_points,
        :short_name
      )
  end

  def all_data
    inter_team_trades
      .joins('JOIN players AS in_players ON inter_team_trades.in_player_id = in_players.id')
      .joins('JOIN players AS out_players ON inter_team_trades.out_player_id = out_players.id')
      .joins('JOIN teams AS in_teams ON in_players.team_id = in_teams.id')
      .joins('JOIN teams AS out_teams ON out_players.team_id = out_teams.id')
      .joins('JOIN positions ON out_players.position_id = positions.id')
      .pluck_to_hash(
        :id,
        'in_players.id AS in_player_id',
        'in_players.last_name AS in_player_last_name',
        'in_teams.short_name AS in_team_short_name',
        'out_players.id AS out_player_id',
        'out_players.last_name AS out_player_last_name',
        'out_teams.short_name AS out_team_short_name',
        :singular_name_short
      )
  end
end
