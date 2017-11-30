class InterTeamTradeGroups::AddToGroup < InterTeamTradeGroups::Base
  object :current_user, class: User

  object :inter_team_trade_group, class: InterTeamTradeGroup

  object :out_fpl_team_list, class: FplTeamList, default: -> { inter_team_trade_group.out_fpl_team_list }
  object :out_fpl_team, class: FplTeam, default: -> { out_fpl_team_list.fpl_team }

  object :in_fpl_team_list, class: FplTeamList, default: -> { inter_team_trade_group.in_fpl_team_list }
  object :in_fpl_team, class: FplTeam, default: -> { in_fpl_team_list.fpl_team }

  object :round, class: Round, default: -> { inter_team_trade_group.round }

  object :in_player, class: Player

  object :out_player, class: Player

  validate :authorised_user_out_fpl_team
  validate :out_player_in_fpl_team
  validate :in_player_in_fpl_team
  validate :identical_player_and_target_positions
  validate :round_is_current
  validate :trade_occurring_in_valid_period
  validate :unique_in_player_in_group
  validate :unique_out_player_in_group
  validate :valid_team_quota_out_fpl_team
  validate :valid_team_quota_in_fpl_team
  validate :inter_team_trade_group_pending
  validate :trade_occurring_in_valid_period

  def execute
    trade = InterTeamTrade.create(
      out_player: out_player,
      in_player: in_player,
      inter_team_trade_group: inter_team_trade_group
    )
    errors.merge!(trade.errors)
    inter_team_trade_group
  end
end
