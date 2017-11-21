class InterTeamTradeGroups::Delete < InterTeamTradeGroups::Base
  object :current_user, class: User
  object :inter_team_trade_group, class: InterTeamTradeGroup
  object :out_fpl_team_list, class: FplTeamList, default: -> { inter_team_trade_group.out_fpl_team_list }
  object :out_fpl_team, class: FplTeam, default: -> { out_fpl_team_list.fpl_team }
  object :round, class: Round, default: -> { inter_team_trade_group.round }

  validate :authorised_user_out_fpl_team
  validate :round_is_current
  validate :trade_occurring_in_valid_period
  validate :inter_team_trade_group_unprocessed
  validate :trade_occurring_in_valid_period

  def execute
    inter_team_trade_group.inter_team_trades.delete_all
    inter_team_trade_group.delete
    errors.merge!(inter_team_trade_group.errors)
  end
end
