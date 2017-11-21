class InterTeamTradeGroups::RemoveFromTradeGroup < InterTeamTradeGroups::Base
  object :current_user, class: User

  object :inter_team_trade_group, class: InterTeamTradeGroup
  object :inter_team_trade, class: InterTeamTrade

  object :out_fpl_team_list, class: FplTeamList, default: -> { inter_team_trade_group.out_fpl_team_list }
  object :out_fpl_team, class: FplTeam, default: -> { out_fpl_team_list.fpl_team }

  object :round, class: Round, default: -> { inter_team_trade_group.round }

  validate :authorised_user_out_fpl_team
  validate :round_is_current
  validate :trade_occurring_in_valid_period
  validate :inter_team_trade_group_pending

  def execute
    trade = inter_team_trade.delete
    errors.merge!(trade.errors)

    inter_team_trade_group.delete if inter_team_trade_group.inter_team_trades.blank?
    errors.merge!(inter_team_trade_group.errors)
  end
end
