class InterTeamTradeGroups::Expire < InterTeamTradeGroups::Base
  object :inter_team_trade_group, class: InterTeamTradeGroup
  object :round, class: Round, default: -> { inter_team_trade_group.round }

  validate :round_deadline_time_passed
  validates :inter_team_trade_group_unprocessed

  run_in_transaction!

  def execute
    inter_team_trade_group.update(status: 'expired')
    errors.merge!(inter_team_trade_group.errors)
  end
end
