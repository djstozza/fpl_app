class TradeGroupsDecorator < SimpleDelegator
  def all_trades
    group_by(&:status).sort.map { |k, v| { status: k.humanize, trade_groups: trade_group_arr(v) } }
  end

  def new_trade_group
    decorator = TradeGroupDecorator.new(
      InterTeamTradeGroup.new(
        out_fpl_team_list: out_fpl_team_list,
        round_id: Round.current_round.id,
        league: out_fpl_team_list.fpl_team.league
      )
    )

    {
      in_players_tradeable: decorator.in_players_tradeable,
      out_players_tradeable: decorator.out_players_tradeable
    }
  end

  private

  def trade_group_arr(trade_groups)
    trade_groups.map do |trade_group|
      decorator = TradeGroupDecorator.new(trade_group)
      {
        id: decorator.id,
        trades: decorator.all_data,
        status: decorator.status,
        in_players_tradeable: decorator.in_players_tradeable,
        out_players_tradeable: decorator.out_players_tradeable,
        out_fpl_team: decorator.out_fpl_team_list.fpl_team,
        in_fpl_team: decorator.in_fpl_team_list.fpl_team
      }
    end
  end
end
