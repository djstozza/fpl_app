class InterTeamTradeGroups::Decline < InterTeamTradeGroups::Base
  object :current_user, class: User
  object :inter_team_trade_group, class: InterTeamTradeGroup
  object :in_fpl_team_list, class: FplTeamList, default: -> { inter_team_trade_group.in_fpl_team_list }
  object :in_fpl_team, class: FplTeam, default: -> { in_fpl_team_list.fpl_team }
  object :round, class: Round, default: -> { inter_team_trade_group.round }

  validate :authorised_user_in_fpl_team
  validate :inter_team_trade_group_unprocessed

  def execute
    inter_team_trade_group.update(status: 'declined')
    errors.merge!(inter_team_trade_group.errors)
    inter_team_trade_group
  end
end
