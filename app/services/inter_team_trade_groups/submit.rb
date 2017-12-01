class InterTeamTradeGroups::Submit < InterTeamTradeGroups::Base
  object :current_user, class: User
  object :inter_team_trade_group, class: InterTeamTradeGroup
  object :out_fpl_team_list, class: FplTeamList, default: -> { inter_team_trade_group.out_fpl_team_list }
  object :in_fpl_team_list, class: FplTeamList, default: -> { inter_team_trade_group.in_fpl_team_list }
  object :out_fpl_team, class: FplTeam, default: -> { out_fpl_team_list.fpl_team }
  object :round, class: Round, default: -> { inter_team_trade_group.round }

  validate :authorised_user_out_fpl_team
  validate :inter_team_trade_group_pending
  validate :trade_occurring_in_valid_period
  validate :no_duplicate_trades

  def execute
    inter_team_trade_group.update(status: 'submitted')
    errors.merge!(inter_team_trade_group.errors)
    inter_team_trade_group
  end
end
