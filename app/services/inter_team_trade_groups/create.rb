class InterTeamTradeGroups::Create < InterTeamTradeGroups::Base
  object :current_user, class: User

  object :inter_team_trade_group, class: InterTeamTradeGroup, default: -> { InterTeamTradeGroup.new }

  object :out_fpl_team_list, class: FplTeamList
  object :in_fpl_team_list, class: FplTeamList

  object :out_fpl_team, class: FplTeam, default: -> { out_fpl_team_list.fpl_team }
  object :in_fpl_team, class: FplTeam, default: -> { in_fpl_team_list.fpl_team }

  object :round, class: Round, default: -> { out_fpl_team_list.round }

  object :in_player, class: Player

  object :out_player, class: Player

  object :league, class: League, default: -> { out_fpl_team.league }

  validate :authorised_user_out_fpl_team
  validate :out_player_in_fpl_team
  validate :in_player_in_fpl_team
  validate :in_fpl_team_in_league
  validate :identical_player_and_target_positions
  validate :round_is_current
  validate :trade_occurring_in_valid_period
  validate :valid_team_quota_out_fpl_team
  validate :valid_team_quota_in_fpl_team

  def execute
    inter_team_trade_group.assign_attributes(
      out_fpl_team_list: out_fpl_team_list,
      in_fpl_team_list: in_fpl_team_list,
      round: round,
      league: league,
      status: 'pending'
    )
    inter_team_trade_group.save
    errors.merge!(inter_team_trade_group.errors)

    trade = InterTeamTrade.create(
      out_player: out_player,
      in_player: in_player,
      inter_team_trade_group: inter_team_trade_group
    )
    errors.merge!(trade.errors)
    inter_team_trade_group
  end
end
